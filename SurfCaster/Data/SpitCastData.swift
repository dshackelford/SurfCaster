//
//  SpitCastController.swift
//  SurfCaster
//
//  Created by Dylan Shackelford on 11/14/18.
//  Copyright © 2018 Dylan Shackelford. All rights reserved.
//

import Foundation
import CoreLocation

/**
 Protocol for receiving data from the internet, in this case the SpitCast API.
 Use the word *Fetch* for internet interactions. 
 */
protocol SpitCastDataDelegate {
    func fetchedTempData(data : WaterTempPacket?, request:DataRequest, county:String, error:Error?)
    
    func fetchedTideData(dataArr : [TidePacket]?, request:DataRequest, county:String, error:Error?)
    
    func fetchedSwellData(dataArr : [SwellPacket]?, request:DataRequest, county:String, error:Error?)
    
    func fetchedWindData(dataArr : [WindPacket]?, request:DataRequest, county:String, error:Error?)
    
    func fetchedAllSpots(dataArr : [SpotPacket]?, error:Error?)
}

/**
 Class for interacting with SpitCast API over the internet.
 Uses the keyword *fetch* to signify it's over the internet.
 */
class SpitCastData{
    var delegate : SpitCastDataDelegate
    
    init(delegateInit : SpitCastDataDelegate) {
        delegate = delegateInit
    }
    
    ///Fetching water temperature data.
    func fetchTempData(forCounty county:String, withRequest request:DataRequest){
        
        let url : URL = URL(string: "http://api.spitcast.com/api/county/water-temperature" + county)!
        let urlrequest = URLRequest(url: url, cachePolicy: NSURLRequest.CachePolicy.returnCacheDataElseLoad, timeoutInterval: 30)
        
        let session = URLSession(configuration: URLSessionConfiguration.default)
        
        let dataTask = session.dataTask(with: urlrequest) { (data, response, error) in
            do{
                let results = try JSONDecoder().decode(WaterTempPacket.self, from:data!)
                print(results)
                self.delegate.fetchedTempData(data: results, request: request, county: county, error: nil)
            }
            catch let error{
                print(error)
                self.delegate.fetchedTempData(data: nil, request:request, county: county, error: error)
            }
        }
        
        dataTask.resume()
    }
    
    ///Fetching tide data.
    func fetchTideData(forCounty county:String, withRequest request:DataRequest){
        let url : URL = URL(string: "http://api.spitcast.com/api/county/tide/" + county + "/?dcat=week")!
        let urlrequest = URLRequest(url: url, cachePolicy: NSURLRequest.CachePolicy.returnCacheDataElseLoad, timeoutInterval: 30)
        
        let session = URLSession(configuration: URLSessionConfiguration.default)
        
        let dataTask = session.dataTask(with: urlrequest) { (data, response, error) in
            do {
                let results = try JSONDecoder().decode([TidePacket].self, from:data!)
                print(results)
                self.delegate.fetchedTideData(dataArr: results, request: request, county: county, error: nil)
            }
            catch let error{
                print(error)
                self.delegate.fetchedTideData(dataArr: nil, request: request, county: county, error: error)
            }
        }
        
        dataTask.resume()
    }
    
    ///Fetching Swell Data.
    func fetchSwellData(forCounty county:String, withRequest request:DataRequest){
        let url : URL = URL(string: "http://api.spitcast.com/api/county/swell/" + county + "/?dcat=week")!
        let urlrequest = URLRequest(url: url, cachePolicy: NSURLRequest.CachePolicy.returnCacheDataElseLoad, timeoutInterval: 30)
        
        let session = URLSession(configuration: URLSessionConfiguration.default)
        
        let dataTask = session.dataTask(with: urlrequest) { (data, response, error) in
            do {
                let packet = try JSONDecoder().decode([SwellPacket].self, from: data!)
                print(packet)
                self.delegate.fetchedSwellData(dataArr: packet,request: request, county: county, error: nil)
            }
            catch let error{
                print(error)
                self.delegate.fetchedSwellData(dataArr: nil, request:request, county: county, error: error)
            }
        }
        dataTask.resume()
    }
    
    ///fetching wind data.
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
                    self.delegate.fetchedWindData(dataArr: results, request:request, county: county, error: nil)
                }
                catch let error{
                    print(error)
                    self.delegate.fetchedWindData(dataArr: nil, request: request, county: county, error: error)
                }
            }
            
            dataTask.resume()
        }
    }
    
    ///fetching all spots on the database.
    func fetchAllSpots(){
        let url = URL(string: "http://api.spitcast.com/api/spot/all")!
        let request = URLRequest(url: url, cachePolicy: NSURLRequest.CachePolicy.returnCacheDataElseLoad, timeoutInterval: 30)
        
        let session = URLSession(configuration: URLSessionConfiguration.default)
        
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            do {
                let results = try JSONDecoder().decode([SpotPacket].self, from:data!)
                print(results)
                self.delegate.fetchedAllSpots(dataArr: results, error: nil)
            }
            catch let error{
                print(error)
                self.delegate.fetchedAllSpots(dataArr: nil, error: error)
            }
        }
        
        dataTask.resume()
    }
}
