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
    func foundTide(tidePackets : [WindPacket])
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
            do{
                let results = try JSONDecoder().decode(WaterTempPacket.self, from:data!)
                print(results)
                self.delegate.foundTemp(tempPacket: results)
            }
            catch let error{
                print(error)
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
                let results = try JSONDecoder().decode([TidePacket].self, from:data!)
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
                let results = try JSONDecoder().decode([WindPacket].self, from:data!)
                print(results)
            }
            catch let error{
                print(error)
            }
        }
        
        dataTask.resume()
    }
}
