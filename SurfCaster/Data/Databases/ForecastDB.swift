//
//  ForecastDB.swift
//  SurfCaster
//
//  Created by Dylan Shackelford on 12/16/18.
//  Copyright © 2018 Dylan Shackelford. All rights reserved.
//

import Foundation
import FMDB
import CoreLocation

/**
 Protocol for interacting with the `ForecastDB`.
 Note keyword of *found* which is standard for database returns.
 */
protocol ForecastDBDelegate {
    func foundWindForecast(data:[WindPacket]?, error:Error?, request:DataRequest)
    func foundTideForecast(data:[TidePacket]?, error:Error?, request:DataRequest)
}

/**
 Database for forecasts.
 Will have 4 tables:
 * `windForecasts`
 > CREATE TABLE IF NOT EXISTS windForecasts (county String, date String, day String, gmtStr String, hour String, WindDirectionDegrees Double, WindDirectionCompass String, WindMagnitudeMPH Double, WindMagnitudeKTS Double)
 * `tideForecasts`
 > CREATE TABLE IF NOT EXISTS tideForecasts (county String, date String, day String, gmtStr String, hour String, TideMagnitudeMeters Double, TideMagnitudeFeet Double)
 * `swellForecasts`
 * `tempForecasts`
 
 Note:
    - Will only keep forecasts from the week prior and a week in the future.
    - This is the database that will be interacted with when the user scrubs into the future, see `ViewController`.
    - If no data is returned, then `DataManager` should fetch new data and update this database accordingly.
 */
class ForecastDB : LocationsDBDelegate {
    
    var dbPath : String
    var db : FMDatabase
    var delegate : ForecastDBDelegate
    init(withDelegate delegateInit:ForecastDBDelegate) {
        dbPath = FileUtilities.getDocsPath()
        dbPath = dbPath + "/SpitCastDB.db"
        db = FMDatabase(path: dbPath)
        delegate = delegateInit
        setUpDB()
    }
    
    func setUpDB(){
        DispatchQueue.main.async {
            if(self.db.open())
            {
                if(self.db.tableExists("windForecasts") == false){
                    do{
                        try self.db.executeUpdate("CREATE TABLE IF NOT EXISTS windForecasts (county String, date String, day String, gmtStr String, hour String, WindDirectionDegrees Double, WindDirectionCompass String, WindMagnitudeMPH Double, WindMagnitudeKTS Double)", values: nil)
                        try self.db.executeUpdate("CREATE TABLE IF NOT EXISTS tideForecasts (county String, date String, day String, gmtStr String, hour String, TideMagnitudeMeters Double, TideMagnitudeFeet Double)", values: nil)
                        self.db.close()
                    }
                    catch
                    {
                        print(error)
                    }
                }
            }
            self.db.close()
        }
    }
    
    func getWindForecast(forRequest request:DataRequest){
        print("Requesting wind forecast from databse.")
        //check if data for data exists
        var arr = Array<WindPacket>()
        if(db.open())
        {
            do{
                let query = "SELECT * FROM windForecasts WHERE gmtStr = '" + findSpitDateFromDate(date: request.date) + "'"
                print(query)
                let set = try db.executeQuery(query, values: nil)

                while set.next()
                {
                    arr.append(WindPacket(withResult: set))
                }
            }catch{
                db.close()
                print(error)
            }
        }
        db.close()
        if(arr.count > 0)
        {
            self.delegate.foundWindForecast(data: arr, error: nil, request: request)
        }
        else
        {
            //add an error framework for this work to max effecientcy
            return self.delegate.foundWindForecast(data: nil, error: nil, request: request);
        }
    }
    
    func getSwellForecast(forRequest request:DataRequest) -> [SwellPacket]?{
        return nil
    }
    
    func getTideForecast(forRequest request:DataRequest){
        DispatchQueue.main.async {
            print("Requesting tide forecast from database.")
            var arr = Array<TidePacket>()
            if(self.db.open())
            {
                do{
                    let query = "SELECT * FROM tideForecasts WHERE gmtStr = '" + self.findSpitDateFromDate(date: request.date) + "'"
                    
                    let set = try self.db.executeQuery(query, values: nil)
                    
                    while set.next()
                    {
                        arr.append(TidePacket(withResult: set))
                    }
                }
                catch{
                    self.db.close()
                    print(error)
                }
            }
            
            self.db.close()
            if(arr.count > 0)
            {
                self.delegate.foundTideForecast(data: arr, error: nil, request: request)
            }
            else
            {
                self.delegate.foundTideForecast(data: nil, error: nil, request: request)
            }
        }
    }
    
    //MARK: - update tables
    func updateTempTable(withArr dataArr:[WaterTempPacket]){
//        for packet in dataArr
//        {
//            if(db.open())
//            {
//                db.executeUpdate("INSERT INTO forecasts", values: <#T##[Any]?#>)
//            }
//        }
    }
    
    func updateWindTable(withArr dataArr:[WindPacket])
    {
        let locDB = LocationsDB(withDelegate: self)
        if(db.open())
        {
            for packet in dataArr
            {
                if(packet.name != nil)
                {
                    let countyName = locDB.convert(PrettyCountyName: packet.name!)
                    do{
                        try db.executeUpdate("INSERT INTO windForecasts (county, date, day, hour, gmtStr, WindDirectionDegrees, WindDirectionCompass, WindMagnitudeMPH, WindMagnitudeKTS) VALUES (?,?,?,?,?,?,?,?,?)", values: [countyName, packet.dateStr!, packet.day! ,packet.hour!, packet.gmt!, packet.directionDegrees!, packet.directionCompass!, packet.speedMPH!, packet.speedKTS!])
                    }
                    catch{
                        db.close()
                        print(error)
                    }
                }
            }
        }
        db.close()
    }
    
    func updateTideTable(withArr dataArr:[TidePacket]){
        let locDB = LocationsDB(withDelegate: self)
        if(db.open())
        {
            for packet in dataArr
            {
                if(packet.name != nil)
                {
                    let countyNAme = locDB.convert(PrettyCountyName: packet.name!)
                    do{
                        try db.executeUpdate("INSERT INTO tideForecasts (county, date, day, hour, gmtStr, TideMagnitudeFeet, TideMagnitudeMeters) VALUES (?,?,?,?,?,?,?)", values: [countyNAme, packet.dateStr!, packet.day!, packet.hour!, packet.gmt!, packet.tideFt!, packet.tideM!])
                    }
                    catch{
                        db.close()
                        print(error)
                    }
                }
            }
        }
        db.close()
    }
    
    func findTimeGMTTimeInterval(From GMTString : String)->TimeInterval{
        
        let arr = GMTString.components(separatedBy: " ")
        var dateStr = arr[0]
        let timeStr = arr[1]
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        dateStr = dateStr + "T00:00:00+0000"
        let baseDate = dateFormatter.date(from: dateStr)

        if(baseDate != nil)
        {
            var baseInterval = baseDate?.timeIntervalSince1970
            
            let hour = Double(timeStr)
            baseInterval = baseInterval! + hour!*60*60
            return baseInterval!
        }
        else
        {
            print("ForecastDB: Error on converting dateStr to Unix timeStamp")
            return Date.init(timeIntervalSince1970: 0).timeIntervalSince1970
        }
    }
    
    func findSpitDateFromDate(date:Date)->String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-M-d' 'H"
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        let gmt = dateFormatter.string(from: date)
        print(gmt)
        return gmt
    }
    
    //MARK: LocationsDBDelegateMethods
    func foundCountyName(name: String?, forLoc loc: CLLocation) {
        
    }
    
    func foundAllSpots(spots: [SpotPacket]?) {
        
    }
}
