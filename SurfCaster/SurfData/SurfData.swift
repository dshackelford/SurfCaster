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


public class TidePacket : Decodable{
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


public class WindPacket : Decodable {
    var dateStr : String
    var day : String
    var directionDegrees : Double
    var directionCompass : String
    var gmt : String
    var hour : String
    var name : String
    var speedKTS : Double
    var speedMPH : Double
    
    enum CodingKeys : String, CodingKey{
        case dateStr = "date"
        case day = "day"
        case directionDegrees = "direction_degrees"
        case directionCompass = "direction_text"
        case gmt = "gmt"
        case hour = "hour"
        case name = "name"
        case speedKTS = "speed_kts"
        case speedMPH = "speed_mph"
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.dateStr = try container.decode(String.self, forKey: .dateStr)
        self.day = try container.decode(String.self, forKey: .day)
        self.directionDegrees = try container.decode(Double.self, forKey: .directionDegrees)
        self.directionCompass = try container.decode(String.self, forKey: .directionCompass)
        self.gmt = try container.decode(String.self, forKey: .gmt)
        self.hour = try container.decode(String.self, forKey: .hour)
        self.name = try container.decode(String.self, forKey: .name)
        self.speedKTS = try container.decode(Double.self, forKey: .speedKTS)
        self.speedMPH = try container.decode(Double.self, forKey: .speedMPH)
    }
}

public class WaterTempPacket : Decodable{
    var buoyId : Int
    var tempC : Float
    var county : String
    var tempF : Float
    var date : String
    var wetsuit : String
    
    enum CodingKeys : String, CodingKey{
        case buoyId = "buoy_id"
        case tempC = "celcius"
        case county = "county"
        case tempF = "fahrenheit"
        case date = "recorded"
        case wetsuit = "wetsuit"
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.buoyId = try container.decode(Int.self, forKey: .buoyId)
        self.tempC = try container.decode(Float.self, forKey: .tempC)
        self.county = try container.decode(String.self, forKey: .county)
        self.tempF = try container.decode(Float.self, forKey: .tempF)
        self.date = try container.decode(String.self, forKey: .date)
        self.wetsuit = try container.decode(String.self, forKey: .wetsuit)
    }
}

public class SwellPacket : Decodable{
    var subSwell1 : SubSwellPacket
    var subSwell2 : SubSwellPacket
    var subSwell3 : SubSwellPacket
    var subSwell4 : SubSwellPacket
    var date : String
    var day : String
    var gmt : String
    var hour : String
    var hst : Double
    var name : String
    
    enum CodingKeys : String, CodingKey{
        case subSwell1 = "0"
        case subSwell2 = "1"
        case subSwell3 = "2"
        case subSwell4 = "3"
        case date = "date"
        case day = "day"
        case gmt = "gmt"
        case hour = "hour"
        case hst = "hst"
        case name = "name"
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.subSwell1 = try container.decode(SubSwellPacket.self, forKey: .subSwell1)
        self.subSwell2 = try container.decode(SubSwellPacket.self, forKey: .subSwell2)
        self.subSwell3 = try container.decode(SubSwellPacket.self, forKey: .subSwell3)
        self.subSwell4 = try container.decode(SubSwellPacket.self, forKey: .subSwell4)
        self.date = try container.decode(String.self, forKey: .date)
        self.day = try container.decode(String.self, forKey: .day)
        self.date = try container.decode(String.self, forKey: .date)
        self.gmt = try container.decode(String.self, forKey: .gmt)
        self.hour = try container.decode(String.self, forKey: .hour)
        self.hst = try container.decode(Double.self, forKey: .hst)
        self.name = try container.decode(String.self, forKey: .name)
    }
    
}


public class SubSwellPacket : Decodable{
    var dir : Double?
    var hs : Double?
    var tp : Double?
    
    enum CodingKeys : String, CodingKey{
        case dir = "dir"
        case hs = "hs"
        case tp = "tp"
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.dir = try container.decode(Double?.self, forKey: .dir)
        self.hs = try container.decode(Double?.self, forKey: .hs)
        self.tp = try container.decode(Double?.self, forKey: .tp)
    }
}

