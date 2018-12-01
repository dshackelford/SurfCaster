//
//  MapView.swift
//  SurfCaster
//
//  Created by Dylan Shackelford on 11/14/18.
//  Copyright © 2018 Dylan Shackelford. All rights reserved.
//

import Foundation
import MapKit

class MapView : MKMapView, MKMapViewDelegate, UIGestureRecognizerDelegate{
    
    var vc : ViewController?
    var lastCenter : CLLocation?
    var currentHeading : Double = 0 //degreee
    
    init(vc: ViewController, frame : CGRect){
        let rotationGesture = UIRotationGestureRecognizer()
        super.init(frame: frame)
        
        rotationGesture.addTarget(self, action: #selector(MapView.handleRotation))
        rotationGesture.delaysTouchesEnded = false
        rotationGesture.delegate = self
        
        self.addGestureRecognizer(rotationGesture)
        
        self.mapType = MKMapType.satellite
        self.showsUserLocation = true
        self.showsTraffic = false
        
        self.delegate = self
        
        self.vc = vc
    }
    
    func gestureRecognizer(_: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith shouldRecognizeSimultaneouslyWithGestureRecognizer:UIGestureRecognizer) -> Bool {
        return true
    }
    
    
    @objc func handleRotation(recognizer:UIRotationGestureRecognizer){
        let recDeg = Double(recognizer.rotation)*180.0/Double.pi
        var offsetHeading = self.camera.heading - recDeg
        
        if(offsetHeading < 0)
        {
           offsetHeading = 360 + offsetHeading
        }
        else if(offsetHeading > 360)
        {
            offsetHeading = offsetHeading - 360
        }
        
        currentHeading = offsetHeading
        
        print("recDeg: " + String(recDeg) + " cameraHeading: " + String(self.camera.heading) + " offsetHeading = " + String(offsetHeading))
        
        vc!.datumView!.headingChanged(heading:currentHeading)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //MARK - MKMapView Delegate Methods
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        let newRegion = MKCoordinateRegion(center: userLocation.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
       
        if(lastCenter == nil)
        {
             self.setRegion(newRegion, animated: true)
             self.lastCenter = CLLocation(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
            print("MapView updated map and last center")
        }
    }
    
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        print("new will heading: " + String(mapView.camera.heading))
        currentHeading = mapView.camera.heading
        vc!.datumView!.headingChanged(heading:currentHeading)
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        print("new did heading: " + String(mapView.camera.heading))
        currentHeading = mapView.camera.heading
        vc!.datumView!.headingChanged(heading:currentHeading)
    }
}
