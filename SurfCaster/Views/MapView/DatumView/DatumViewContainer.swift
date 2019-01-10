//
//  DatumController.swift
//  SurfCaster
//
//  Created by Dylan Shackelford on 11/14/18.
//  Copyright © 2018 Dylan Shackelford. All rights reserved.
//

import Foundation
import CoreGraphics
import UIKit
import CoreLocation

protocol DatumViewPresenter {
    func rotateAccordingToAngle(angle : Double)
    func updateAccordingToLocation(loc : CLLocation)
    func updateAccodringToTime(hour : Int)
    func hide()
    func show()
}

/**
 Container view for the 3 `Datum` views (Swell/WaterTemp, Wind/AirTemp, Tide).
 All 3 datums are live, but only one is not hidden.
 A `Datum` is made up of the following itmes
    * Circle ring
    * A minimum of one triangle pointer
    * Info label inside the circle ring
 `Datum` classes allow for unique additions on top of this if necessary, see `SwellDatumPresenter`.
 */
class DatumViewContainer : UIView{
    var mapView : MapView?
    var screenSize : CGSize
    var periodCircle : CAShapeLayer?
    var periodAngle : Double
    var dataManager : DataManager?
    
    var location : CLLocation
    var time : Date
    
    var currentDatumIndex : Int
    var presenters : [DatumViewPresenter]
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(initWithMap mapViewInit :MapView){
        mapView = mapViewInit
        screenSize = UIScreen.main.bounds.size
        periodAngle = 0
        currentDatumIndex = 0
        location = CLLocation(latitude: 0,longitude: 0)
        time = Date(timeIntervalSinceNow: 0)
        
        var myFrame : CGRect
        if(UserDefaults.standard.object(forKey: "DatumOriginX") != nil)
        {
            let x = UserDefaults.standard.float(forKey: "DatumOriginX")
            let y = UserDefaults.standard.float(forKey: "DatumOriginY")
            myFrame = CGRect(x: CGFloat(x), y: CGFloat(y), width: screenSize.width/2.0, height:screenSize.width/2.0)
        }
        else
        {
            myFrame = CGRect(x: screenSize.width/4.0, y: screenSize.height/2.0 - screenSize.width/4.0, width: screenSize.width/2.0, height:screenSize.width/2.0)
        }

        presenters = Array<DatumViewPresenter>()
        super.init(frame: myFrame)
        
        let presenterFrame = CGRect(x: 0, y: 0, width: myFrame.width, height: myFrame.height)
        let windDatumPresenter = WindDatumPresenter.init(frame: presenterFrame, andContainer: self)
        let swellDatumPresenter = SwellDatumPresenter.init(frame: presenterFrame, andContainer: self)
        let tideDatumPresenter = TideDatumPresenter.init(frame: presenterFrame, andContainer: self)

        presenters.append(windDatumPresenter)
        presenters.append(swellDatumPresenter)
        presenters.append(tideDatumPresenter)
        
    
        
        dataManager = DataManager()
        
        mapView!.addSubview(self)
        self.addSubview(windDatumPresenter)
        self.addSubview(swellDatumPresenter)
        self.addSubview(tideDatumPresenter)
        iterateThroughDatumPresenters()
        addGestures()
        
        Drawer().drawCircle(toView: self, forCenter: CGPoint(x: self.frame.size.width/2, y: self.frame.size.height/2), andRadius: self.frame.size.width/2, andColor: UIColor.black)
    }
    
    ///Cycles through the `Datum'`s when the user taps on the DatumContainer.
    func iterateThroughDatumPresenters(){
        for i in 0..<presenters.count
        {
            let presenter = presenters[i]
            if(i == currentDatumIndex)
            {
                presenter.show()
            }
            else
            {
                presenter.hide()
            }
        }
        currentDatumIndex = currentDatumIndex + 1
        if(currentDatumIndex >= presenters.count)
        {
            currentDatumIndex = 0
        }
    }
    
    
    //MARK: - Gesture Recognizers
    func addGestures(){
        
        let panGesture = UIPanGestureRecognizer()
        panGesture.addTarget(self, action:#selector(DatumViewContainer.handlePan))
        self.addGestureRecognizer(panGesture)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(DatumViewContainer.handleTap))
        tapGesture.delaysTouchesEnded = false
        self.addGestureRecognizer(tapGesture)
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(DatumViewContainer.hangleLongPress))
        longPress.delaysTouchesEnded = false
        self.addGestureRecognizer(longPress)
    }
    
    @objc func hangleLongPress(recognizer : UILongPressGestureRecognizer){
        print("handle long press and show more information")
    }
    
    @objc func handleTap(recognizer : UITapGestureRecognizer){
        iterateThroughDatumPresenters()
    }
    
    @objc func handlePan(recognizer:UIPanGestureRecognizer){
        let translation = recognizer.translation(in: self)
        
        self.center = CGPoint(x: self.center.x + translation.x, y: self.center.y + translation.y)
        
        recognizer.setTranslation(CGPoint.zero, in: self)
        print(self.frame.origin.x)
        UserDefaults.standard.set(self.frame.origin.x, forKey: "DatumOriginX")
        UserDefaults.standard.set(self.frame.origin.y, forKey: "DatumOriginY")
    }
    
    //MARK: - Environment Changes
    ///Letting `Datum`'s know to update there heading respsectively.
    func headingChanged(heading:Double)
    {
        for i in 0..<presenters.count
        {
            presenters[i].rotateAccordingToAngle(angle: heading)
        }
    }
    
    ///Letting `Datum`'s know to update their current location.
    func locationChanged(location:CLLocation){
        for i in 0..<presenters.count
        {
            presenters[i].updateAccordingToLocation(loc: location)
        }
        //request for upated data
    }
    
    //Letting `Datum`'s know to update there current hour (time).
    func timeChanged(hour:Int){
        //look into future dataset for information to present
        for i in 0..<presenters.count
        {
            presenters[i].updateAccodringToTime(hour: hour)
        }
    }
}
