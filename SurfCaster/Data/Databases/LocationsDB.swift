//
//  LocationsDB.swift
//  
//
//  Created by Dylan Shackelford on 12/16/18.
//

import Foundation
import FMDB
import CoreLocation

/**
 Protocol for interacting with the `LocationsDB`.
 Note keyword of *found* which is standard for database returns.
 */
protocol LocationsDBDelegate {
    func foundCountyName(name:String?, forLoc loc:CLLocation)
    func foundAllSpots(spots:[SpotPacket]?)
}

/**
 Database for holding Spitcast locational information
 > CREATE TABLE IF NOT EXISTS locations (spotID INT, spotName String, lat Double, lon Double, countyName String)
 */
class LocationsDB {
    
    var dbPath : String
    var db : FMDatabase
    var delegate : LocationsDBDelegate
    
    init(withDelegate delegateInit:LocationsDBDelegate) {
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
                if(self.db.tableExists("locations") == false){
                    do{
                        try self.db.executeUpdate("CREATE TABLE IF NOT EXISTS locations (spotID INT, spotName String, lat Double, lon Double, countyName String)", values: nil)
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
    
    func getCountyNameFromLoc(loc:CLLocation){
        DispatchQueue.main.async {
            if(self.db.open())
            {
                do{
                    let query = "SELECT * FROM locations"
                    
                    var minDist = Double.infinity
                    var closeCounty : String?
                    let results = try self.db.executeQuery(query, values:nil)
                    
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
                        self.delegate.foundCountyName(name: self.convert(PrettyCountyName: closeCounty!), forLoc: loc)
                    }
                    else
                    {
                        self.delegate .foundCountyName(name: nil, forLoc: loc)
                    }
                }
                catch{
                    print(error)
                    self.delegate .foundCountyName(name: nil, forLoc: loc)
                }
            }
            self.delegate .foundCountyName(name: nil, forLoc: loc)
        }
    }
    
    func convert(PrettyCountyName:String)->String{
        let str = PrettyCountyName.replacingOccurrences(of: " ", with: "-")
        return str.lowercased()
    }
    
    func getAllSpots(){
        DispatchQueue.main.async {
            var arr = Array<SpotPacket>()
            if(self.db.open())
            {
                do{
                    let query = "SELECT * FROM locations"
                    let results = try self.db.executeQuery(query, values: nil)
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
            if(arr.count > 0)
            {
                self.delegate.foundAllSpots(spots: arr)
            }
            else
            {
                self.delegate.foundAllSpots(spots: nil)
            }
        }
    }
    
    func update(withAllSpots arr:[SpotPacket]){
        DispatchQueue.main.async {
            if(self.db.open())
            {
                //update the locations
                for spot in arr
                {
                    do{
                        try self.db.executeUpdate("INSERT INTO locations (spotID, spotName,lat,lon, countyName) VALUES (?,?,?,?,?)", values: [spot.spotID!,spot.spotName!,spot.lat!,spot.lon!,spot.county!])
                    }
                    catch
                    {
                        print(error)
                    }
                }
            }
        }
    }
    
}
