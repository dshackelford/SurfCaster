//
//  DataManager.swift
//  SurfCaster
//
//  Created by Dylan Shackelford on 12/1/18.
//  Copyright © 2018 Dylan Shackelford. All rights reserved.
//

import Foundation
import CoreLocation
import FMDB

class DataManager : NSObject,SpitCastDataDelegate{

    var spitDB : FMDatabase
    var spitDBPath : String
    
    override init() {
        spitDBPath = FileUtilities.getDocsPath()
        spitDBPath = spitDBPath + "/SpitCastDB.db"
        spitDB = FMDatabase(path: spitDBPath)
        super.init()
        setUpDB()
    }
    
    func setUpDB(){
        if(spitDB.open())
        {
            if(spitDB.tableExists("locations") == false){
                do{
                    try spitDB.executeUpdate("CREATE TABLE IF NOT EXISTS locations (spotID INT, spotName String, lat Double, lon Double, countyName String)", values: nil)
                    
                    let spitData = SpitCastData(delegateInit: self)
                    spitDB.close()
                    spitData.getAllSpots()
                }
                catch
                {
                    print(error)
                }
            }
        }
        
        spitDB.close()
    }
    
    func getWindForecast(forLocation loc : CLLocation, andDate date:NSDate, andReceiver receiver:SpitCastDataDelegate){
        
        let countyName = getCountyNameFromLoc(loc: loc)
        //check local database for return
        //if not, grab some from online
            //tell receiver immediately
            //update the local database
        let spitData = SpitCastData(delegateInit: receiver)
        if(countyName != nil)
        {
            spitData.getWindData(forCounty:countyName!)
        }
        else
        {
            print("DataManager: Error getting a countyName from a lcoation")
        }
    }
    
    func getSwellForecast(forLocation loc : CLLocation, andDate date:NSDate){
    }
    
    func getWaterTempForecast(forLocation loc : CLLocation, andDate date:NSDate){
    }
    
    func getAirTempForecast(forLocation loc : CLLocation, andDate date:NSDate){
    }
    
    func getTideForecast(forLocation loc : CLLocation, andDate date:NSDate){
    }
    
    
    func getCountyNameFromLoc(loc:CLLocation)->String?{
        if(spitDB.open())
        {
            do{
                let query = "SELECT * FROM locations"
                
                var minDist = Double.infinity
                var closeCounty : String?
                let results = try spitDB.executeQuery(query, values:nil)
                
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
        if(spitDB.open())
        {
            do{
                let query = "SELECT * FROM locations"
                let results = try spitDB.executeQuery(query, values: nil)
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
    
    //MARK: - SpitCastData Delegate Methods
    func foundTempData(data: WaterTempPacket, county: String) {
        
    }
    
    func tempDataError(error: Error) {
        
    }
    
    func foundTideData(dataArr: [TidePacket], county: String) {
        
    }
    
    func tideDataError(error: Error) {
        
    }
    
    func foundSwellData(dataArr: [SwellPacket], county: String) {
        
    }
    
    func swellDataError(error: Error) {
        
    }
    
    func foundWindData(dataArr: [WindPacket], county: String) {
//        self.receiver
    }
    
    func windDataError(error: Error) {
        
    }
    
    func foundAllSpots(dataArr: [SpotPacket]) {
        if(spitDB.open())
        {
            //update the locations
            for spot in dataArr
            {
                do{
                    try spitDB.executeUpdate("INSERT INTO locations (spotID, spotName,lat,lon, countyName) VALUES (?,?,?,?,?)", values: [spot.spotID,spot.spotName,spot.lat,spot.lon,spot.county])
                }
                catch
                {
                    print(error)
                }
            }
        }
    }
    
    func allSpotsError(error: Error) {
        
    }
    
}
