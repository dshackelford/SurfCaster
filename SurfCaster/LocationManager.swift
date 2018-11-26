//
//  LocationManager.swift
//  SurfCaster
//
//  Created by Dylan Shackelford on 11/14/18.
//  Copyright © 2018 Dylan Shackelford. All rights reserved.
//

import Foundation
import CoreLocation
import MapKit

class LocationManager : CLLocationManager, CLLocationManagerDelegate{
    
    var vc : ViewController?
    
    init(vc:ViewController) {
        super.init()
        self.delegate = self
        self.vc = vc
        enableAuthorization()
        startUpdatingHeading()
//        startUpdatingLocation()
    }
    
    func enableAuthorization(){
        requestWhenInUseAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        print("LocationManager: updating heading: " + String(newHeading.trueHeading))
        if(vc?.aMapView?.isMoving == false){
            vc?.aMapView?.camera.heading = newHeading.trueHeading
        }
    }
    
    
}
