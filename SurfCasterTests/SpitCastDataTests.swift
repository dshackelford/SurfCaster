//
//  SpitCastDataTests.swift
//  SurfCasterTests
//
//  Created by Dylan Shackelford on 11/24/18.
//  Copyright © 2018 Dylan Shackelford. All rights reserved.
//

import XCTest

class SpitCastDataTests: XCTestCase, SpitCastDataDelegate {
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
        
    }
    
    func windDataError(error: Error) {
        
    }
    
    func foundAllSpots(dataArr: [SpotPacket]) {
        
    }
    
    func allSpotsError(error: Error) {
        
    }
    

    var tideSuccess : XCTestExpectation?
    var tideFail : XCTestExpectation?
    var tempSuccess : XCTestExpectation?
    var tempFail : XCTestExpectation?
    
    func testTideData(){
        tideSuccess = XCTestExpectation(description: "Tide Data")
        let spitData = SpitCastData(delegateInit: self)
        spitData.getTideData(forCounty: "Orange-County")
        wait(for: [tideSuccess!], timeout: 60)
    }
    
    func testTemperatureData() {
        tempSuccess = XCTestExpectation()
        
        let spitData = SpitCastData(delegateInit: self)
        spitData.getTempData(forCounty: "Orange-County")
        wait(for: [tempSuccess!], timeout: 60)
    }
    
    func testSwellDAta() {
        tempSuccess = XCTestExpectation()
        
        let spitData = SpitCastData(delegateInit: self)
        spitData.getSwellData(forCounty: "Orange-County")
        wait(for: [tempSuccess!], timeout: 60)
    }
    
    func testWindData() {
        tempSuccess = XCTestExpectation()
        
        let spitData = SpitCastData(delegateInit: self)
        spitData.getWindData(forCounty: "Orange-County")
        wait(for: [tempSuccess!], timeout: 60)
    }
    
    func testAllSpots(){
        tempSuccess = XCTestExpectation()
        let spitData = SpitCastData(delegateInit: self)
        spitData.getAllSpots()
        wait(for: [tempSuccess!], timeout: 60)
    }
    
    
    

}
