//
//  DataManagerTests.swift
//  SurfCasterTests
//
//  Created by Dylan Shackelford on 12/2/18.
//  Copyright © 2018 Dylan Shackelford. All rights reserved.
//

import XCTest
import CoreLocation

class DataManagerTests: XCTestCase, DataManagerReceiver {
    
    var windSuccess : XCTestExpectation?
    
    func testGettingWind(){
        windSuccess = XCTestExpectation(description: "Wind expectation of success")
        
        let manager = DataManager()
        let loc = CLLocation(latitude: 32.7465030, longitude: -117.247067)
        let today = Date(timeIntervalSinceNow: 0)
        let request = DataRequest(withDate: today, andLocation: loc, forReceiver: self)
        let windData = manager.getWindForecast(withReqest: request)
        
        if(windData == nil)
        {
            wait(for: [windSuccess!], timeout: 60)
        }
        else
        {
            windSuccess!.fulfill()
        }
    }
    
    func testGettingWindFromDB(){
        
    }
    
    func testGettingWindFail(){
    
    }
    
    
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
