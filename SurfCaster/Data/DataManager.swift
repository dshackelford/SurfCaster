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

/**
 Protocol for interacting with the DataManager.
 See `DatumPresenters` for implementation.
 */
protocol DataManagerReceiver {
    func windForecastReceived(withData arr:[WindPacket]?, fromRequest request:DataRequest, andError error:Error?)
    func swellForecastReceived(withData arr:[SwellPacket]?, fromRequest request:DataRequest, andError error:Error?)
    func tideForecastReceived(withData arr:[TidePacket]?, fromRequest request:DataRequest, andError error:Error?)
    func tempForecastReceived(withData arr:[WaterTempPacket]?, fromRequest request:DataRequest, andError error:Error?)
    func wait(fromRequest request:DataRequest)
}

protocol DataRequestCreator {
    func requestCreated(request:DataRequest)
}
/*
 Description holder for a request for some forecast data.
 */
class DataRequest : LocationsDBDelegate{
    var date : Date
    var loc : CLLocation
    var receiver : DataManagerReceiver
    var fetching : Bool
    var countyName : String?
    var creator : DataRequestCreator
    
    init(withDate dateInit:Date, andLocation locInit:CLLocation, forReceiver receiverInit: DataManagerReceiver, andCreator creatorInit:DataRequestCreator ) {
        creator = creatorInit
        date = dateInit
        loc = locInit
        receiver = receiverInit
        fetching = false
        let locDB = LocationsDB(withDelegate: self)
        locDB.getCountyNameFromLoc(loc: loc)
        //include a date range in here? maybe start and end date. if there is no end date, then only use the start date?
    }
    
    func foundAllSpots(spots: [SpotPacket]?) {
        
    }
    
    func foundCountyName(name: String?, forLoc loc: CLLocation) {
        countyName = name
        creator.requestCreated(request: self)
    }
}

/*
 The "Middle-Man" between the Datum presenters and the information sources of the internet fetcher `SpitCastData` and local storage `ForecastDB`.
 This manager handles all the logic for determining where the data comes from. 
 */
class DataManager : NSObject, SpitCastDataDelegate, LocationsDBDelegate, ForecastDBDelegate{
    
    var locDB : LocationsDB!
    var forecastDB : ForecastDB!
    var requests : [DataRequest]
    
    override init() {
        requests = Array<DataRequest>()
        super.init()
        locDB = LocationsDB(withDelegate: self)
        forecastDB = ForecastDB(withDelegate: self)
        locDB.getAllSpots()
    }
    
    func getWindForecast(withRequest request:DataRequest){
        //check local database for return
        forecastDB.getWindForecast(forRequest: request)
    }
    
    func getSwellForecast(withRequest request:DataRequest){
        forecastDB.getSwellForecast(forRequest: request)
    }
    
    func getWaterTempForecast(forLocation loc : CLLocation, andDate date:NSDate){
    }
    
    func getAirTempForecast(forLocation loc : CLLocation, andDate date:NSDate){
    }
    
    func getTideForecast(withRequest request:DataRequest) {
        forecastDB.getTideForecast(forRequest: request)
    }

    
    //MARK: - SpitCastData Delegate Methods
    func fetchedTempData(data: WaterTempPacket?, request: DataRequest, county: String, error: Error?) {
        
    }
    
    func fetchedTideData(dataArr: [TidePacket]?, request: DataRequest, county: String, error: Error?) {
        //add it to the forecast database for later re-use
        if(error == nil && dataArr!.count > 0)
        {
            forecastDB.updateTideTable(withArr: dataArr!)
        }
        
        //pass it onto the receiver, probably a datum presenter
        request.receiver.tideForecastReceived(withData: dataArr, fromRequest: request, andError: error)
    }
    
    func fetchedSwellData(dataArr: [SwellPacket]?, request: DataRequest, county: String, error: Error?) {
        if(error == nil && dataArr!.count > 0)
        {
            forecastDB.updateSwellTable(withArr: dataArr!)
        }
        
        request.receiver.swellForecastReceived(withData: dataArr, fromRequest: request, andError: error)
    }
    
    func fetchedWindData(dataArr: [WindPacket]?, request: DataRequest, county: String, error: Error?) {
        //add it tot the forecast database!
        if(error == nil && dataArr!.count > 0)
        {
            forecastDB.updateWindTable(withArr: dataArr!)
        }
        //pass it on to the receiver
        request.receiver.windForecastReceived(withData: dataArr, fromRequest: request,andError: error)
    }

    func fetchedAllSpots(dataArr: [SpotPacket]?, error: Error?) {
        if(error == nil && dataArr != nil)
        {
            locDB.update(withAllSpots: dataArr!)
        }
        else
        {
            print(error!.localizedDescription)
        }
    }
    
    //MARK: - LocationDB Delegate
    func foundCountyName(name:String?, forLoc loc:CLLocation){
        
    }
    
    func foundAllSpots(spots:[SpotPacket]?){
        if(spots != nil && spots!.count == 0)
        {
            let spitData = SpitCastData(delegateInit: self)
            spitData.fetchAllSpots()
        }
        else
        {
            print("Alert use that there is no spot data")
        }
    }
    
    //MARK: - ForecastDB Delegate
    func foundWindForecast(data:[WindPacket]?, error:Error?, request:DataRequest) {
        if(data != nil)
        {
            request.receiver.windForecastReceived(withData: data!, fromRequest: request, andError: nil)
        }
        else //if not, grab some from online
        {
            let spitData = SpitCastData(delegateInit: self)
            if(request.countyName != nil)
            {
                spitData.fetchWindData(forCounty:request.countyName!, withRequest:request)
            }
            else
            {
                spitData.fetchAllSpots() //get all spots from the internet and update the local database
                
                print("DataManager: Error getting a countyName from a location")
            }
        }
    }
    
    func foundTideForecast(data:[TidePacket]?, error:Error?, request:DataRequest) {
        if(data != nil)
        {
            request.receiver.tideForecastReceived(withData: data, fromRequest: request, andError: nil)
        }
        else
        {
            let spitData = SpitCastData(delegateInit: self)
            if(request.countyName != nil)
            {
                spitData.fetchTideData(forCounty: request.countyName!, withRequest: request)
            }
            else
            {
                spitData.fetchAllSpots()
            }
        }
    }
    
    func foundSwellForecast(data: [SwellPacket]?, error: Error?, request: DataRequest) {
        if(data != nil)
        {
            request.receiver.swellForecastReceived(withData: data, fromRequest: request, andError: nil)
        }
        else
        {
            let spitData = SpitCastData(delegateInit: self)
            if(request.countyName != nil)
            {
                spitData.fetchSwellData(forCounty: request.countyName!, withRequest: request)
            }
            else
            {
                spitData.fetchAllSpots()
            }
        }
    }
}
