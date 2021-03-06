//
//  MapView.swift
//  SurfCaster
//
//  Created by Dylan Shackelford on 11/14/18.
//  Copyright © 2018 Dylan Shackelford. All rights reserved.
//

import Foundation
import MapKit

/**
 `MKMapView` holding the surf data `Datum`'s.
 Handles the users location and heading via `MKMapView` delegate methods.
 
 */
class MapView : MKMapView, MKMapViewDelegate, UIGestureRecognizerDelegate, LocationsDBDelegate{
    var vc : ViewController?
    var lastCenter : CLLocation?
    var currentHeading : Double = 0 //degreee
    var timeSlider : UISlider?
    var datumView : DatumViewContainer?
    
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
        
        let locDB = LocationsDB(withDelegate: self)
        locDB.getAllSpots()
        
        self.vc = vc
        
        addTimeSlider()
        
        datumView = DatumViewContainer(initWithMap:self)
    }
    
    func addTimeSlider()
    {
        let screenSize = UIScreen.main.bounds.size
        timeSlider = UISlider(frame: CGRect(x: 20, y: screenSize.height-60, width: screenSize.width - 2*20, height: 20))
        timeSlider!.addTarget(self, action: #selector(MapView.sliderChangedValue), for: UIControl.Event.valueChanged)
        timeSlider!.minimumValue = 0
        timeSlider!.maximumValue = 23
        self.addSubview(timeSlider!)
    }
    
    ///Method for changing the time. Informs all `Datum`'s that the time has changed.
    @objc func sliderChangedValue(){
        print("slider value = " + String(timeSlider!.value))
        
        datumView!.timeChanged(hour: Int(timeSlider!.value))
    }
    
    func gestureRecognizer(_: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith shouldRecognizeSimultaneouslyWithGestureRecognizer:UIGestureRecognizer) -> Bool {
        return true
    }
    
    ///When the use rotates the map, they are changing the heading of the `Datum`'s
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
        
        datumView!.headingChanged(heading:currentHeading)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //MARK: - MKMapView Delegate Methods
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        let newRegion = MKCoordinateRegion(center: userLocation.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
       
        if(lastCenter == nil)
        {
             self.setRegion(newRegion, animated: true)
             self.lastCenter = CLLocation(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
            print("MapView updated map and last center")
            datumView!.locationChanged(location: lastCenter!)
        }
        
        let userLoc = CLLocation(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
        let dist = Double((lastCenter?.distance(from: userLoc))!)
        
        if(dist > 10000.0)
        {
            datumView!.locationChanged(location: userLoc)
        }
    }
    
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        print("new will heading: " + String(mapView.camera.heading))
        currentHeading = mapView.camera.heading
        datumView!.headingChanged(heading:currentHeading)
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        print("new did heading: " + String(mapView.camera.heading))
        currentHeading = mapView.camera.heading
        datumView!.headingChanged(heading:currentHeading)
    }
    
    //MARK: - LocationsDBDelegate Methods
    func foundAllSpots(spots: [SpotPacket]?) {
        if(spots != nil)
        {
            for aSpot in spots!
            {
                if(aSpot.lat != nil && aSpot.lon != nil)
                {
                    let anno = MKPointAnnotation()
                    anno.coordinate = CLLocationCoordinate2DMake(aSpot.lat!, aSpot.lon!)
                    anno.title = aSpot.spotName
                    anno.subtitle = aSpot.county
                    self.addAnnotation(anno)
                }
            }
        }
    }
    
    func foundCountyName(name: String?, forLoc loc: CLLocation) {
        
    }
}
