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

class DataManager : SpitCastDataDelegate{
    

    var locDB : LocationsDB
    
    init() {
        locDB = LocationsDB()
    }
    
    func getWindForecast(forLocation loc : CLLocation, andDate date:NSDate, andReceiver receiver:SpitCastDataDelegate){
        
        let countyName = locDB.getCountyNameFromLoc(loc: loc)
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

    
    //MARK: - SpitCastData Delegate Methods
    func foundTempData(data: WaterTempPacket?, county: String, error: Error?) {
        
    }
    
    func foundTideData(dataArr: [TidePacket]?, county: String, error: Error?) {
        
    }
    
    func foundSwellData(dataArr: [SwellPacket]?, county: String, error: Error?) {
        
    }
    
    func foundWindData(dataArr: [WindPacket]?, county: String, error: Error?) {
        
    }
    
    func foundAllSpots(dataArr: [SpotPacket]?, error: Error?) {
        
    }
}
