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
    func foundTempData(data : WaterTempPacket?, request:DataRequest, county:String, error:Error?)
    
    func foundTideData(dataArr : [TidePacket]?, request:DataRequest, county:String, error:Error?)
    
    func foundSwellData(dataArr : [SwellPacket]?, request:DataRequest, county:String, error:Error?)
    
    func foundWindData(dataArr : [WindPacket]?, request:DataRequest, county:String, error:Error?)
    
    func foundAllSpots(dataArr : [SpotPacket]?, error:Error?)
}


class SpitCastData{
    
    var delegate : SpitCastDataDelegate
    var forecastDB : ForecastDB
    
    init(delegateInit : SpitCastDataDelegate) {
        delegate = delegateInit
        forecastDB = ForecastDB()
    }
    
    func fetchTempData(forCounty county:String, withRequest request:DataRequest){
        
        let url : URL = URL(string: "http://api.spitcast.com/api/county/water-temperature" + county)!
        let urlrequest = URLRequest(url: url, cachePolicy: NSURLRequest.CachePolicy.returnCacheDataElseLoad, timeoutInterval: 30)
        
        let session = URLSession(configuration: URLSessionConfiguration.default)
        
        let dataTask = session.dataTask(with: urlrequest) { (data, response, error) in
            do{
                let results = try JSONDecoder().decode(WaterTempPacket.self, from:data!)
                print(results)
                self.delegate.foundTempData(data: results, request: request, county: county, error: nil)
            }
            catch let error{
                print(error)
                self.delegate.foundTempData(data: nil, request:request, county: county, error: error)
            }
        }
        
        dataTask.resume()
    }
    
    
    func fetchTideData(forCounty county:String, withRequest request:DataRequest){
        let url : URL = URL(string: "http://api.spitcast.com/api/county/tide/" + county + "/?dcat=week")!
        let urlrequest = URLRequest(url: url, cachePolicy: NSURLRequest.CachePolicy.returnCacheDataElseLoad, timeoutInterval: 30)
        
        let session = URLSession(configuration: URLSessionConfiguration.default)
        
        let dataTask = session.dataTask(with: urlrequest) { (data, response, error) in
            do {
                let results = try JSONDecoder().decode([TidePacket].self, from:data!)
                print(results)
                self.delegate.foundTideData(dataArr: results, request: request, county: county, error: nil)
            }
            catch let error{
                print(error)
                self.delegate.foundTideData(dataArr: nil, request: request, county: county, error: error)
            }
        }
        
        dataTask.resume()
    }
    
    
    func fetchSwellData(forCounty county:String, withRequest request:DataRequest){
        let url : URL = URL(string: "http://api.spitcast.com/api/county/swell/" + county + "/?dcat=week")!
        let urlrequest = URLRequest(url: url, cachePolicy: NSURLRequest.CachePolicy.returnCacheDataElseLoad, timeoutInterval: 30)
        
        let session = URLSession(configuration: URLSessionConfiguration.default)
        
        let dataTask = session.dataTask(with: urlrequest) { (data, response, error) in
            do {
                let packet = try JSONDecoder().decode([SwellPacket].self, from: data!)
                print(packet)
                self.delegate.foundSwellData(dataArr: packet,request: request, county: county, error: nil)
            }
            catch let error{
                print(error)
                self.delegate.foundSwellData(dataArr: nil, request:request, county: county, error: error)
            }
        }
        dataTask.resume()
    }
    
    func fetchWindData(forCounty county:String, withRequest request:DataRequest){
        let str =  "http://api.spitcast.com/api/county/wind/" + county + "/?dcat=week"
        let url : URL? = URL(string: str)
        if(url != nil)
        {
            let urlrequest = URLRequest(url: url!, cachePolicy: NSURLRequest.CachePolicy.returnCacheDataElseLoad, timeoutInterval: 30)
            
            let session = URLSession(configuration: URLSessionConfiguration.default)
            
            let dataTask = session.dataTask(with: urlrequest) { (data, response, error) in
                do {
                    if(error != nil)
                    {
                        throw error!
                    }
                    let results = try JSONDecoder().decode([WindPacket].self, from:data!)
                    print(results)
                    self.delegate.foundWindData(dataArr: results, request:request, county: county, error: nil)
                }
                catch let error{
                    print(error)
                    self.delegate.foundWindData(dataArr: nil, request: request, county: county, error: error)
                }
            }
            
            dataTask.resume()
        }
    }
    
    func fetchAllSpots(){
        let url = URL(string: "http://api.spitcast.com/api/spot/all")!
        let request = URLRequest(url: url, cachePolicy: NSURLRequest.CachePolicy.returnCacheDataElseLoad, timeoutInterval: 30)
        
        let session = URLSession(configuration: URLSessionConfiguration.default)
        
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            do {
                let results = try JSONDecoder().decode([SpotPacket].self, from:data!)
                print(results)
                self.delegate.foundAllSpots(dataArr: results, error: nil)
            }
            catch let error{
                print(error)
                self.delegate.foundAllSpots(dataArr: nil, error: error)
            }
        }
        
        dataTask.resume()
    }
}
