//
//  SpitCastDataTests.swift
//  SurfCasterTests
//
//  Created by Dylan Shackelford on 11/24/18.
//  Copyright © 2018 Dylan Shackelford. All rights reserved.
//

import XCTest

class SpitCastDataTests: XCTestCase, SpitCastDataDelegate {

    var tideSuccess : XCTestExpectation?
    var tideFail : XCTestExpectation?
    var tempSuccess : XCTestExpectation?
    var tempFail : XCTestExpectation?
    
    func testTideData(){
        tideSuccess = XCTestExpectation(description: "Tide Data")
        let spitData = SpitCastData(delegateInit: self)
        spitData.getSomeTideData()
        wait(for: [tideSuccess!], timeout: 60)
    }
    
    func testTemperatureData() {
        tempSuccess = XCTestExpectation()
        
        let spitData = SpitCastData(delegateInit: self)
        spitData.getSomeTempData()
        wait(for: [tempSuccess!], timeout: 60)
    }
    
    func testSwellDAta() {
        tempSuccess = XCTestExpectation()
        
        let spitData = SpitCastData(delegateInit: self)
        spitData.getSomeSwellData()
        wait(for: [tempSuccess!], timeout: 60)
    }
    
    func testWindData() {
        tempSuccess = XCTestExpectation()
        
        let spitData = SpitCastData(delegateInit: self)
        spitData.getSomeWindData()
        wait(for: [tempSuccess!], timeout: 60)
    }
    
    
    func foundTemp(tempPacket: WaterTempPacketClass) {
        tempSuccess?.fulfill()
    }
    
    func tempDataError() {
        tempFail?.fulfill()
    }
    
    func foundTide(tidePackets tidePacket: [WindPacketClass]) {
        tideSuccess?.fulfill()
    }
    

}
