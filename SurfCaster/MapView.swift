//
//  MapView.swift
//  SurfCaster
//
//  Created by Dylan Shackelford on 11/14/18.
//  Copyright © 2018 Dylan Shackelford. All rights reserved.
//

import Foundation
import MapKit

class MapView : MKMapView, MKMapViewDelegate{
    
    var vc : ViewController?
    var lastCenter : CLLocation?
    var isMoving : Bool = false
    
    init(vc: ViewController, frame : CGRect){
        super.init(frame: frame)
        
        self.mapType = MKMapType.satellite
        self.showsUserLocation = true
        self.showsTraffic = false
        
        self.delegate = self
        
        self.vc = vc
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //MARK - MKMapView Delegate Methods
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        let newRegion = MKCoordinateRegion(center: userLocation.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        self.setRegion(newRegion, animated: true)
        self.lastCenter = CLLocation(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
        print("MapView updated map and last center")
    }
    
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        print("MapView: RegionWillChange")
        self.isMoving = true;
    }
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        print("MapView: RegionDidChange")
        self.isMoving = false;
    }
}
