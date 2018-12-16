//
//  LocationsDB.swift
//  
//
//  Created by Dylan Shackelford on 12/16/18.
//

import Foundation
import FMDB
import CoreLocation

class LocationsDB : SpitCastDataDelegate{
    
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
            if(db.tableExists("locations") == false){
                do{
                    try db.executeUpdate("CREATE TABLE IF NOT EXISTS locations (spotID INT, spotName String, lat Double, lon Double, countyName String)", values: nil)
                    
                    let spitData = SpitCastData(delegateInit: self)
                    db.close()
                    spitData.getAllSpots()
                }
                catch
                {
                    print(error)
                }
            }
        }
        
        db.close()
    }
    
    func getCountyNameFromLoc(loc:CLLocation)->String?{
        if(db.open())
        {
            do{
                let query = "SELECT * FROM locations"
                
                var minDist = Double.infinity
                var closeCounty : String?
                let results = try db.executeQuery(query, values:nil)
                
                while results.next(){
                    let lat = results.double(forColumn: "lat")
                    let lon = results.double(forColumn: "lon")
                    let locB = CLLocation(latitude: lat, longitude: lon)
                    let dist = locB.distance(from: loc)
                    if(dist < minDist)
                    {
                        minDist = dist
                        closeCounty = results.string(forColumn: "countyName")!
                    }
                }
                
                if(closeCounty != nil)
                {
                    let str = closeCounty!.replacingOccurrences(of: " ", with: "-")
                    return str.lowercased()
                }
                else
                {
                    return nil
                }
            }
            catch{
                print(error)
                return nil
            }
        }
        return nil
    }
    
    func getAllSpots()->[SpotPacket]{
        var arr = Array<SpotPacket>()
        if(db.open())
        {
            do{
                let query = "SELECT * FROM locations"
                let results = try db.executeQuery(query, values: nil)
                while results.next(){
                    let lat = results.double(forColumn: "lat")
                    let lon = results.double(forColumn: "lon")
                    let name = results.string(forColumn: "spotName")
                    let spotId = results.int(forColumn: "spotID")
                    let countyName = results.string(forColumn: "countyName")
                    
                    let spot = SpotPacket(latInit: lat, lonInit: lon, spotIDInit: Int(spotId), spotNameInit: name!, countyName: countyName!)
                    
                    arr.append(spot)
                }
            }
            catch{
                print("DataManager: getAllSpots: " + error.localizedDescription)
            }
        }
        
        return arr
    }
    
    //MARK: SpitCastDataDelegateMethods
    func foundAllSpots(dataArr: [SpotPacket]?, error: Error?) {
        if(error == nil && dataArr != nil)
        {
            if(db.open())
            {
                //update the locations
                for spot in dataArr!
                {
                    do{
                        try db.executeUpdate("INSERT INTO locations (spotID, spotName,lat,lon, countyName) VALUES (?,?,?,?,?)", values: [spot.spotID,spot.spotName,spot.lat,spot.lon,spot.county])
                    }
                    catch
                    {
                        print(error)
                    }
                }
            }
        }
    }
    
    func foundTempData(data: WaterTempPacket?, county: String, error: Error?) {
        
    }
    
    func foundTideData(dataArr: [TidePacket]?, county: String, error: Error?) {
        
    }
    
    func foundSwellData(dataArr: [SwellPacket]?, county: String, error: Error?) {
        
    }
    
    func foundWindData(dataArr: [WindPacket]?, county: String, error: Error?) {
        
    }
    
}
