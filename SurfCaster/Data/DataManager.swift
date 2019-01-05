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

protocol DataManagerReceiver {
    func windForecastReceived(withData arr:[WindPacket]?, fromRequest request:DataRequest, andError error:Error?)
    func swellForecastReceived(withData arr:[WindPacket]?, fromRequest request:DataRequest, andError error:Error?)
    func tideForecastReceived(withData arr:[WindPacket]?, fromRequest request:DataRequest, andError error:Error?)
    func tempForecastReceived(withData arr:[WindPacket]?, fromRequest request:DataRequest, andError error:Error?)
    func wait(fromRequest request:DataRequest)
}

class DataRequest{
    var date : Date
    var loc : CLLocation
    var receiver : DataManagerReceiver
    var fetching : Bool
    
    init(withDate dateInit:Date, andLocation locInit:CLLocation, forReceiver receiverInit: DataManagerReceiver) {
        date = dateInit
        loc = locInit
        receiver = receiverInit
        fetching = false
    }
}

class DataManager : NSObject, SpitCastDataDelegate{
    
    var locDB : LocationsDB
    var forecastDB : ForecastDB
    var requests : [DataRequest]
    
    override init() {
        locDB = LocationsDB()
        forecastDB = ForecastDB()
        requests = Array<DataRequest>()
        super.init()

        if(locDB.getAllSpots().count == 0)
        {
            let spitData = SpitCastData(delegateInit: self)
            spitData.fetchAllSpots()
        }
    }
    
    func getWindForecast(withReqest request:DataRequest){
        
        let countyName = locDB.getCountyNameFromLoc(loc: request.loc)
        
        //check local database for return
        let windPacket = forecastDB.getWindForecast(forDate: request.date)
        if(windPacket != nil)
        {
            request.receiver.windForecastReceived(withData: windPacket!, fromRequest: request, andError: nil)
        }
        else //if not, grab some from online
        {
            let spitData = SpitCastData(delegateInit: self)
            if(countyName != nil)
            {
                spitData.fetchWindData(forCounty:countyName!, withRequest:request)
            }
            else
            {
                spitData.fetchAllSpots() //get all spots from the internet and update the local database
                
                print("DataManager: Error getting a countyName from a location")
            }
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
    func foundTempData(data: WaterTempPacket?, request: DataRequest, county: String, error: Error?) {
        
    }
    
    func foundTideData(dataArr: [TidePacket]?, request: DataRequest, county: String, error: Error?) {
        
    }
    
    func foundSwellData(dataArr: [SwellPacket]?, request: DataRequest, county: String, error: Error?) {
        
    }
    
    func foundWindData(dataArr: [WindPacket]?, request: DataRequest, county: String, error: Error?) {
        //add it tot the forecast database!
        if(error == nil && dataArr!.count > 0)
        {
            forecastDB.updateWindTable(withArr: dataArr!)
        }
        //pass it on to the receiver
        request.receiver.windForecastReceived(withData: dataArr, fromRequest: request,andError: error)
    }

    func foundAllSpots(dataArr: [SpotPacket]?, error: Error?) {
        if(error == nil && dataArr != nil)
        {
            locDB.update(withAllSpots: dataArr!)
        }
        else
        {
            print(error!.localizedDescription)
        }
    }
}
