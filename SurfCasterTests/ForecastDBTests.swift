//
//  ForecastDBTests.swift
//  SurfCasterTests
//
//  Created by Dylan Shackelford on 12/16/18.
//  Copyright © 2018 Dylan Shackelford. All rights reserved.
//

import XCTest

class ForecastDBTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testTestDateStrConversion(){
        
        var dateArr = Array<String>()
        var intervalArr = Array<Double>()
        dateArr.append("2018-12-16 9")
        intervalArr.append(1544950800)
        
        dateArr.append("2018-12-16 19")
        intervalArr.append(1544986800)
        
        
        let forecastDB = ForecastDB()
        
        for i in 0..<dateArr.count
        {
             let timeInterval = forecastDB.findTimeGMTTimeInterval(From: dateArr[i])
            XCTAssertTrue(timeInterval == intervalArr[i])
        }
    }

}
