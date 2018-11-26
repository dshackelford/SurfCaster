//
//  SurfData.swift
//  SurfCaster
//
//  Created by Dylan Shackelford on 11/14/18.
//  Copyright © 2018 Dylan Shackelford. All rights reserved.
//

import Foundation
import CoreLocation

protocol SurfData {
    func getSwellData(forLoc loc:CLLocation)
    func getTideData(forLoc loc: CLLocation)
}

protocol SurfDataReceiver {
    func swellDataReceived(data : SwellData)
    func tideDataReceived(data : TideData)
}

protocol SwellData { //no setters required, i.e. readonly
    var magnitude : Double {get}
    var direction : Double {get} //degrees
    var location : CLLocation {get}
}

protocol TideData {
    var magnitude : Double {get}
    var location : CLLocation {get}
}

protocol WindData {
    var magnitude : Double {get}
    var direction : Double {get} //degrees
    var location : CLLocation {get}
}


public class TidePacketClass : Decodable{
    var dateStr : String
    var day : String
    var dateNum : String
    var time : String
    var name : String
    var tideFt : Double
    var tideM : Double
    
    private enum CodingKeys: String, CodingKey {
        case dateStr = "date"
        case day = "day"
        case dateNum = "gmt"
        case time = "hour"
        case name = "name"
        case tideFt = "tide"
        case tideM = "tide_meters"
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.dateStr = try container.decode(String.self, forKey: .dateStr)
        self.day = try container.decode(String.self, forKey: .day)
        self.dateNum = try container.decode(String.self, forKey: .dateNum)
        self.time = try container.decode(String.self, forKey: .time)
        self.name = try container.decode(String.self, forKey: .name)
        self.tideFt = try container.decode(Double.self, forKey: .tideFt)
        self.tideM = try container.decode(Double.self, forKey: .tideM)
    }
}
