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
    
    override init() {
        super.init()
        self.delegate = self
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
//        print("LocationManager: updating heading: " + String(newHeading.trueHeading))
    }
    
    
}
