//
//  SpitCastController.swift
//  SurfCaster
//
//  Created by Dylan Shackelford on 11/14/18.
//  Copyright © 2018 Dylan Shackelford. All rights reserved.
//

import Foundation
import CoreLocation

protocol SpitCastDataDelegate {
    func foundTempData(data : WaterTempPacket, county:String)
    func tempDataError(error:Error)
    
    func foundTideData(dataArr : [TidePacket], county:String)
    func tideDataError(error:Error)
    
    func foundSwellData(dataArr : [SwellPacket], county:String)
    func swellDataError(error:Error)
    
    func foundWindData(dataArr : [WindPacket], county:String)
    func windDataError(error:Error)
    
    func foundAllSpots(dataArr : [SpotPacket])
    func allSpotsError(error:Error)
}


class SpitCastData{
    
    var delegate : SpitCastDataDelegate
    
    init(delegateInit : SpitCastDataDelegate) {
        delegate = delegateInit
    }
    
    func getTempData(forCounty county:String){
        
        let url : URL = URL(string: "http://api.spitcast.com/api/county/water-temperature/" + county)!
        let request = URLRequest(url: url, cachePolicy: NSURLRequest.CachePolicy.returnCacheDataElseLoad, timeoutInterval: 30)
        
        let session = URLSession(configuration: URLSessionConfiguration.default)
        
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            do{
                let results = try JSONDecoder().decode(WaterTempPacket.self, from:data!)
                print(results)
                self.delegate.foundTempData(data: results, county: county)
            }
            catch let error{
                print(error)
                self.delegate.tempDataError(error: error)
            }
        }
        
        dataTask.resume()
    }
    
    
    func getTideData(forCounty county:String){
        let url : URL = URL(string: "http://api.spitcast.com/api/county/tide/" + county)!
        let request = URLRequest(url: url, cachePolicy: NSURLRequest.CachePolicy.returnCacheDataElseLoad, timeoutInterval: 30)
        
        let session = URLSession(configuration: URLSessionConfiguration.default)
        
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            do {
                let results = try JSONDecoder().decode([TidePacket].self, from:data!)
                print(results)
                self.delegate.foundTideData(dataArr: results, county: county)
            }
            catch let error{
                print(error)
                self.delegate.tideDataError(error: error)
            }
        }
        
        dataTask.resume()
    }
    
    
    func getSwellData(forCounty county:String){
        let url : URL = URL(string: "http://api.spitcast.com/api/county/swell/" + county)!
        let request = URLRequest(url: url, cachePolicy: NSURLRequest.CachePolicy.returnCacheDataElseLoad, timeoutInterval: 30)
        
        let session = URLSession(configuration: URLSessionConfiguration.default)
        
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            do {
                let packet = try JSONDecoder().decode([SwellPacket].self, from: data!)
                print(packet)
                self.delegate.foundSwellData(dataArr: packet, county: county)
            }
            catch let error{
                print(error)
                self.delegate.swellDataError(error: error)
            }
        }
        dataTask.resume()
    }
    
    func getWindData(forCounty county:String){
        let str =  "http://api.spitcast.com/api/county/wind/" + county
        let url : URL? = URL(string: str)
        if(url != nil)
        {
            let request = URLRequest(url: url!, cachePolicy: NSURLRequest.CachePolicy.returnCacheDataElseLoad, timeoutInterval: 30)
            
            let session = URLSession(configuration: URLSessionConfiguration.default)
            
            let dataTask = session.dataTask(with: request) { (data, response, error) in
                do {
                    if(error != nil)
                    {
                        throw error!
                    }
                    let results = try JSONDecoder().decode([WindPacket].self, from:data!)
                    print(results)
                    self.delegate.foundWindData(dataArr: results, county: county)
                }
                catch let error{
                    print(error)
                    self.delegate.windDataError(error: error)
                }
            }
            
            dataTask.resume()
        }
    }
    
    func getAllSpots(){
        let url = URL(string: "http://api.spitcast.com/api/spot/all")!
        let request = URLRequest(url: url, cachePolicy: NSURLRequest.CachePolicy.returnCacheDataElseLoad, timeoutInterval: 30)
        
        let session = URLSession(configuration: URLSessionConfiguration.default)
        
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            do {
                let results = try JSONDecoder().decode([SpotPacket].self, from:data!)
                print(results)
                self.delegate.foundAllSpots(dataArr: results)
            }
            catch let error{
                print(error)
                self.delegate.allSpotsError(error: error)
            }
        }
        
        dataTask.resume()
    }
}
