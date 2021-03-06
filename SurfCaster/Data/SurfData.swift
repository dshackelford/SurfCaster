//
//  SurfData.swift
//  SurfCaster
//
//  Created by Dylan Shackelford on 11/14/18.
//  Copyright © 2018 Dylan Shackelford. All rights reserved.
//

import Foundation
import CoreLocation
import FMDB

///Data packet implementation for Tide information.
public class TidePacket : Decodable{
    var dateStr : String?
    var day : String?
    var gmt : String?
    var hour : String?
    var name : String?
    var tideFt : Double?
    var tideM : Double?
    
    private enum CodingKeys: String, CodingKey {
        case dateStr = "date"
        case day = "day"
        case gmt = "gmt"
        case hour = "hour"
        case name = "name"
        case tideFt = "tide"
        case tideM = "tide_meters"
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.dateStr = try container.decode(String.self, forKey: .dateStr)
        self.day = try container.decode(String.self, forKey: .day)
        self.gmt = try container.decode(String.self, forKey: .gmt)
        self.hour = try container.decode(String.self, forKey: .hour)
        self.name = try container.decode(String.self, forKey: .name)
        self.tideFt = try container.decode(Double.self, forKey: .tideFt)
        self.tideM = try container.decode(Double.self, forKey: .tideM)
    }
    
    public init(withResult result:FMResultSet){
        self.dateStr = result.string(forColumn: "date")
        self.day = result.string(forColumn: "day")
        self.gmt = result.string(forColumn: "gmtStr")
        self.hour = result.string(forColumn: "hour")
        self.name = result.string(forColumn: "county")
        self.tideM = result.double(forColumn: "TideMagnitudeMeters")
        self.tideFt = result.double(forColumn: "TideMagnitudeFeet")
    }
}

///Data packet implementation for Wind information.
public class WindPacket : Decodable {
    var dateStr : String?
    var day : String?
    var directionDegrees : Double?
    var directionCompass : String?
    var gmt : String?
    var hour : String?
    var name : String?
    var speedKTS : Double?
    var speedMPH : Double?
    
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
        do{
            self.dateStr = try container.decode(String.self, forKey: .dateStr)
            self.day = try container.decode(String.self, forKey: .day)
            self.directionDegrees = try container.decode(Double.self, forKey: .directionDegrees)
            self.directionCompass = try container.decode(String.self, forKey: .directionCompass)
            self.gmt = try container.decode(String.self, forKey: .gmt)
            self.hour = try container.decode(String.self, forKey: .hour)
            self.name = try container.decode(String.self, forKey: .name)
            self.speedKTS = try container.decode(Double.self, forKey: .speedKTS)
            self.speedMPH = try container.decode(Double.self, forKey: .speedMPH)
            print("created a wind packet successfully")
        }
        catch{
            print("ruh rul")
        }
    }
    
    public init(withResult result:FMResultSet){
        self.dateStr = result.string(forColumn: "date")
        self.day = result.string(forColumn: "day")
        self.directionDegrees = result.double(forColumn: "WindDirectionDegrees")
        self.directionCompass = result.string(forColumn: "WindDirectionCompass")
        self.gmt = result.string(forColumn: "gmtStr")
        self.hour = result.string(forColumn: "hour")
        self.name = result.string(forColumn: "county")
        self.speedKTS = result.double(forColumn: "WindMagnitudeKTS")
        self.speedMPH = result.double(forColumn: "WindMagnitudeMPH")
    }
}

///Data packet implementation for Water Temperature information.
public class WaterTempPacket : Decodable{
    var buoyId : Int?
    var tempC : Float?
    var county : String?
    var tempF : Float?
    var date : String?
    var wetsuit : String?
    
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

///Data packet implementation for Swell information.
public class SwellPacket : Decodable{
    var subSwells : [SubSwellPacket]
//    var subSwell1 : SubSwellPacket?
//    var subSwell2 : SubSwellPacket?
//    var subSwell3 : SubSwellPacket?
//    var subSwell4 : SubSwellPacket?
    var dateStr : String?
    var day : String?
    var gmt : String?
    var hour : String?
    var hst : Double?
    var name : String?
    var uuid : String?
    
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
        let subSwell1 = try container.decode(SubSwellPacket?.self, forKey: .subSwell1)
        let subSwell2 = try container.decode(SubSwellPacket?.self, forKey: .subSwell2)
        let subSwell3 = try container.decode(SubSwellPacket?.self, forKey: .subSwell3)
        let subSwell4 = try container.decode(SubSwellPacket?.self, forKey: .subSwell4)
        self.subSwells = Array<SubSwellPacket>()
        if(subSwell1 != nil)
        {
            self.subSwells.append(subSwell1!)
        }
        
        if(subSwell2 != nil)
        {
            self.subSwells.append(subSwell2!)
        }
        
        if(subSwell3 != nil)
        {
            self.subSwells.append(subSwell3!)
        }
        
        if(subSwell4 != nil)
        {
            self.subSwells.append(subSwell4!)
        }
        self.dateStr = try container.decode(String.self, forKey: .date)
        self.day = try container.decode(String.self, forKey: .day)
        self.gmt = try container.decode(String.self, forKey: .gmt)
        self.hour = try container.decode(String.self, forKey: .hour)
        self.hst = try container.decode(Double.self, forKey: .hst)
        self.name = try container.decode(String.self, forKey: .name)
        self.uuid = UUID().uuidString
    }
    
//    public init(withResult result:FMResultSet){
//        
//    }
    
}

///Data packet implementation for SubSwell information.
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

///Data packet implementation for Spot information.
public class SpotPacket : Decodable{
    var county : String?
    var lat : Double?
    var lon : Double?
    var spotID : Int?
    var spotName : String?
    
    
    enum CodingKeys : String, CodingKey{
        case county = "county_name"
        case lat = "latitude"
        case lon = "longitude"
        case spotID = "spot_id"
        case spotName = "spot_name"
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.county = try container.decode(String.self, forKey: .county)
        self.lat = try container.decode(Double.self, forKey: .lat)
        self.lon = try container.decode(Double.self, forKey: .lon)
        self.spotID = try container.decode(Int.self, forKey: .spotID)
        self.spotName = try container.decode(String.self, forKey: .spotName)
    }
    
    init(latInit:Double, lonInit:Double, spotIDInit:Int, spotNameInit:String, countyName:String){
        
        lat = latInit
        lon = lonInit
        spotID = spotIDInit
        spotName = spotNameInit
        county = countyName
    }
}
