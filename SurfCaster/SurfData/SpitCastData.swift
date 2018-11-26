//
//  SpitCastController.swift
//  SurfCaster
//
//  Created by Dylan Shackelford on 11/14/18.
//  Copyright © 2018 Dylan Shackelford. All rights reserved.
//

import Foundation

protocol SpitCastDataDelegate {
    func foundTemp(tempPacket: WaterTempPacket)
    func tempDataError()
    func foundTide(tidePacket : TidePacket)
}


class SpitCastData{
    
    var delegate : SpitCastDataDelegate
    
    init(delegateInit : SpitCastDataDelegate) {
        delegate = delegateInit
    }
    
    func getSomeTempData(){
        
        let url : URL = URL(string: "http://api.spitcast.com/api/county/water-temperature/orange-county/")!
        let request = URLRequest(url: url, cachePolicy: NSURLRequest.CachePolicy.returnCacheDataElseLoad, timeoutInterval: 30)
        
        let session = URLSession(configuration: URLSessionConfiguration.default)
        
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            if let data = data{
                guard let packet = try? JSONDecoder().decode(WaterTempPacket.self, from: data) else {
                    self.delegate.tempDataError()
                    print("Error: couldn't decode data into swell packet")
                    return
                }
                print("packet title: \(packet.wetsuit)")
                self.delegate.foundTemp(tempPacket: packet)
            }
            
        }
        
        dataTask.resume()
    }
    
    
    func getSomeTideData(){
        let url : URL = URL(string: "http://api.spitcast.com/api/county/tide/orange-county/")!
        let request = URLRequest(url: url, cachePolicy: NSURLRequest.CachePolicy.returnCacheDataElseLoad, timeoutInterval: 30)
        
        let session = URLSession(configuration: URLSessionConfiguration.default)
        
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            do {
//                let packet = try JSONDecoder().decode([TidePacket].self, from: data!)
//                print(packet)
//            }
//            catch let error{
//                print(error)
//            }
            
                let results = try JSONDecoder().decode([TidePacketClass].self, from:data!)
                print(results)
            }
            catch let error{
                print(error)
            }
        }
        
        dataTask.resume()
    }
    
    
    func getSomeSwellData(){
        let url : URL = URL(string: "http://api.spitcast.com/api/county/swell/orange-county/")!
        let request = URLRequest(url: url, cachePolicy: NSURLRequest.CachePolicy.returnCacheDataElseLoad, timeoutInterval: 30)
        
        let session = URLSession(configuration: URLSessionConfiguration.default)
        
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            do {
                let packet = try JSONDecoder().decode([SwellPacket].self, from: data!)
                print(packet)
            }
            catch let error{
                print(error)
            }
        }
        dataTask.resume()
    }
    
    func getSomeWindData(){
        let url : URL = URL(string: "http://api.spitcast.com/api/county/wind/orange-county/")!
        let request = URLRequest(url: url, cachePolicy: NSURLRequest.CachePolicy.returnCacheDataElseLoad, timeoutInterval: 30)
        
        let session = URLSession(configuration: URLSessionConfiguration.default)
        
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            do {
                let packet = try JSONDecoder().decode([WindPacket].self, from: data!)
                print(packet)
            }
            catch let error{
                print(error)
            }
        }
        
        dataTask.resume()
    }
}

public struct SwellPacket : Decodable{
    let subSwell1 : SubSwellPacket
    let subSwell2 : SubSwellPacket
    let subSwell3 : SubSwellPacket
    let subSwell4 : SubSwellPacket
    let date : String
    let day : String
    let gmt : String
    let hour : String
    let hst : Double
    let name : String
    
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
    
}

public struct SubSwellPacket : Decodable{
    
    let dir : Double?
    let hs : Double?
    let tp : Double?
    
    enum CodingKeys : String, CodingKey{
        case dir = "dir"
        case hs = "hs"
        case tp = "tp"
    }
}

public struct WaterTempPacket : Decodable{
    let buoyId : Int
    let tempC : Float
    let county : String
    let tempF : Float
    let date : String
    let wetsuit : String
    
    enum CodingKeys : String, CodingKey{
        case buoyId = "buoy_id"
        case tempC = "celcius"
        case county = "county"
        case tempF = "fahrenheit"
        case date = "recorded"
        case wetsuit = "wetsuit"
    }
}


public struct TidePacket : Decodable {
    let dateStr : String
    let day : String
    let dateNum : String
    let time : String
    let name : String
    let tideFt : Double
    let tideM : Double
    
    enum CodingKeys : String, CodingKey{
        case dateStr = "date"
        case day = "day"
        case dateNum = "gmt"
        case time = "hour"
        case name = "name"
        case tideFt = "tide"
        case tideM = "tide_meters"
    }
}

//public class TidePacketClass : Decodable{
//    var dateStr : String
//    var day : String
//    var dateNum : String
//    var time : String
//    var name : String
//    var tideFt : Double
//    var tideM : Double
//    
//    private enum CodingKeys: String, CodingKey {
//        case dateStr = "date"
//        case day = "day"
//        case dateNum = "gmt"
//        case time = "hour"
//        case name = "name"
//        case tideFt = "tide"
//        case tideM = "tide_meters"
//    }
//    
//    required public init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        self.dateStr = try container.decode(String.self, forKey: .dateStr)
//        self.day = try container.decode(String.self, forKey: .day)
//        self.dateNum = try container.decode(String.self, forKey: .dateNum)
//        self.time = try container.decode(String.self, forKey: .time)
//        self.name = try container.decode(String.self, forKey: .name)
//        self.tideFt = try container.decode(Double.self, forKey: .tideFt)
//        self.tideM = try container.decode(Double.self, forKey: .tideM)
//    }
//}

public struct WindPacket : Decodable {
    let dateStr : String
    let day : String
    let directionDegrees : Double
    let directionCompass : String
    let gmt : String
    let hour : String
    let name : String
    let speedKTS : Double
    let speedMPH : Double
    
    
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
}
