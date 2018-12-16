//
//  DataManagerTests.swift
//  SurfCasterTests
//
//  Created by Dylan Shackelford on 12/2/18.
//  Copyright © 2018 Dylan Shackelford. All rights reserved.
//

import XCTest
import CoreLocation

class DataManagerTests: XCTestCase, DataReceiver {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testGettingCountyFromLocation() {
        let manager = DataManager(receiverInit: self)
        let countStr = manager.getCountyNameFromLoc(loc: CLLocation(latitude: 32.750016, longitude: -117.251587))
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
