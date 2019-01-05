//
//  ForecastDB.swift
//  SurfCaster
//
//  Created by Dylan Shackelford on 12/16/18.
//  Copyright © 2018 Dylan Shackelford. All rights reserved.
//

import Foundation
import FMDB

class ForecastDB {
    
    var dbPath : String
    var db : FMDatabase
    init() {
        dbPath = FileUtilities.getDocsPath()
        dbPath = dbPath + "/SpitCastDB.db"
        db = FMDatabase(path: dbPath)
        setUpDB()
    }
    
    func setUpDB(){
        if(db.open())
        {
            if(db.tableExists("windForecasts") == false){
                do{
                    try db.executeUpdate("CREATE TABLE IF NOT EXISTS windForecasts (county String, date String, day String, gmtStr String UNIQUE, hour String, WindDirectionDegrees Double, WindDirectionCompass String, WindMagnitudeMPH Double, WindMagnitudeKTS Double)", values: nil)
                    try db.executeUpdate("CREATE TABLE IF NOT EXISTS tideForecasts (county String, date Date, hour Int, TideMagnitude Double)", values: nil)
//                    try db.executeUpdate("CREATE TABLE IF NOT EXISTS swellForecasts (county String, date Date, hour Int, TideMagnitude Double)", values: nil)
                    db.close()
                }
                catch
                {
                    print(error)
                }
            }
        }
        db.close()
    }
    
    func getWindForecast(forDate date:Date) -> [WindPacket]?{
        print("Requesting wind forecast from databse.")
        //check if data for data exists
        var arr = Array<WindPacket>()
        if(db.open())
        {
            do{
                let query = "SELECT * FROM WindForecasts WHERE date = '" + findSpitDateFromDate(date: date) + "'"
                print(query)
                let set = try db.executeQuery(query, values: nil)

                while set.next()
                {
                    arr.append(WindPacket(withResult: set))
                }
            }catch{
                print(error)
            }
        }
        db.close()
        if(arr.count > 0)
        {
            return arr
        }
        else
        {
            return nil;
        }
    }
    
    func getSwellForecast(forDate date:Date) -> SwellPacket?{
        return nil
    }
    
    func getTideForecast(forDate date:Date) -> TidePacket?{
        return nil
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
        let locDB = LocationsDB()
        for packet in dataArr
        {
            if(db.open())
            {
                if(packet.name != nil)
                {
                    let countyName = locDB.convert(PrettyCountyName: packet.name!)
                    do{
                        try db.executeUpdate("INSERT INTO windForecasts (county, date, day, hour, gmtStr, WindDirectionDegrees, WindDirectionCompass, WindMagnitudeMPH, WindMagnitudeKTS) VALUES (?,?,?,?,?,?,?,?,?)", values: [countyName, packet.dateStr!, packet.day! ,packet.hour!, packet.gmt!, packet.directionDegrees!, packet.directionCompass!, packet.speedMPH!, packet.speedKTS!])
                    }
                    catch{
                        print(error)
                    }
                }
            }
        }
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
}
