//
//  SpitCastDataTests.swift
//  SurfCasterTests
//
//  Created by Dylan Shackelford on 11/24/18.
//  Copyright © 2018 Dylan Shackelford. All rights reserved.
//

import XCTest
import CoreLocation

class SpitCastDataTests: XCTestCase, SpitCastDataDelegate, DataManagerReceiver {
    

    var tideSuccess : XCTestExpectation?
    var tideFail : XCTestExpectation?
    var tempSuccess : XCTestExpectation?
    var tempFail : XCTestExpectation?
    
    func testTideData(){
        tideSuccess = XCTestExpectation(description: "Tide Data")
        let spitData = SpitCastData(delegateInit: self)
        let request = DataRequest(withDate: Date(timeIntervalSinceNow: 0), andLocation: CLLocation(latitude: 0, longitude: 0), forReceiver: self)
        spitData.fetchTideData(forCounty: "orange-county", withRequest: request)
        wait(for: [tideSuccess!], timeout: 60)
    }
    
    func testTideDataFail(){
        tideFail = XCTestExpectation(description: "Tide data fail with bad county name")
        let spitData = SpitCastData(delegateInit: self)
        let request = DataRequest(withDate: Date(timeIntervalSinceNow: 0), andLocation: CLLocation(latitude: 0, longitude: 0), forReceiver: self)
        spitData.fetchTideData(forCounty: "Orangeounty", withRequest: request)
        wait(for: [tideFail!], timeout: 60)
    }
    
    func testTemperatureData() {
        tempSuccess = XCTestExpectation()
        let request = DataRequest(withDate: Date(timeIntervalSinceNow: 0), andLocation: CLLocation(latitude: 0, longitude: 0), forReceiver: self)
        let spitData = SpitCastData(delegateInit: self)
        spitData.fetchTempData(forCounty: "orange-county", withRequest: request)
        wait(for: [tempSuccess!], timeout: 60)
    }
    
    func testSwellDAta() {
        tempSuccess = XCTestExpectation()
        
        let spitData = SpitCastData(delegateInit: self)
        let request = DataRequest(withDate: Date(timeIntervalSinceNow: 0), andLocation: CLLocation(latitude: 0, longitude: 0), forReceiver: self)
        spitData.fetchSwellData(forCounty: "orange-county", withRequest: request)
        wait(for: [tempSuccess!], timeout: 60)
    }
    
    func testWindData() {
        tempSuccess = XCTestExpectation()
        
        let spitData = SpitCastData(delegateInit: self)
        let request = DataRequest(withDate: Date(timeIntervalSinceNow: 0), andLocation: CLLocation(latitude: 0, longitude: 0), forReceiver: self)
        spitData.fetchWindData(forCounty: "orange-county", withRequest: request)
        wait(for: [tempSuccess!], timeout: 60)
    }
    
    func testAllSpots(){
        tempSuccess = XCTestExpectation()
        let spitData = SpitCastData(delegateInit: self)
        spitData.fetchAllSpots()
        wait(for: [tempSuccess!], timeout: 60)
    }
    
    
    func foundTempData(data: WaterTempPacket?, county: String, error: Error?) {
        
    }
    
    func foundTideData(dataArr: [TidePacket]?, county: String, error: Error?) {
        if(tideSuccess != nil)
        {
            if(dataArr != nil)
            {
                tideSuccess?.fulfill()
            }
        }
        else if(tideFail != nil)
        {
            if(error != nil)
            {
                print(error!.localizedDescription)
                tideFail?.fulfill()
            }
        }
    }
    func foundTempData(data: WaterTempPacket?, request: DataRequest, county: String, error: Error?) {
        if(tideSuccess != nil)
        {
            if(data != nil)
            {
                tideSuccess?.fulfill()
            }
        }
        else if(tideFail != nil)
        {
            if(error != nil)
            {
                print(error!.localizedDescription)
                tideFail?.fulfill()
            }
        }
    }
    
    func foundTideData(dataArr: [TidePacket]?, request: DataRequest, county: String, error: Error?) {
        
    }
    
    func foundSwellData(dataArr: [SwellPacket]?, request: DataRequest, county: String, error: Error?) {
        
    }
    
    func foundWindData(dataArr: [WindPacket]?, request: DataRequest, county: String, error: Error?) {
        
    }
    
    func foundAllSpots(dataArr: [SpotPacket]?, error: Error?) {
        
    }
    
    
    
    //MARK: - DataManagerReceiver
    func windForecastReceived(withData arr: [WindPacket]?, fromRequest request: DataRequest, andError error: Error?) {
        
    }
    
    func swellForecastReceived(withData arr: [WindPacket]?, fromRequest request: DataRequest, andError error: Error?) {
        
    }
    
    func tideForecastReceived(withData arr: [WindPacket]?, fromRequest request: DataRequest, andError error: Error?) {
        
    }
    
    func tempForecastReceived(withData arr: [WindPacket]?, fromRequest request: DataRequest, andError error: Error?) {
        
    }
    
    func wait(fromRequest request: DataRequest) {
        
    }

}
