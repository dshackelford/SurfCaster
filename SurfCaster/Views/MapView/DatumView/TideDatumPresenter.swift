//
//  TideDatumViewPresenter.swift
//  SurfCaster
//
//  Created by Dylan Shackelford on 12/1/18.
//  Copyright © 2018 Dylan Shackelford. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

/**
 Handles the presentation of Tide Data.
 Holds math for caculating the partial circle and showing the direction of the indicator triangle.
 Indicator triangle will only be point up or down, for the tide coming in or out. 
 */
class TideDatumPresenter: UIView , DatumViewPresenter, DataManagerReceiver {
    var container : DatumViewContainer
    var dataManager : DataManager
    var maxTide : Double
    var minTide : Double
    
    init(frame: CGRect, andContainer containerInit:DatumViewContainer) {
        
        container = containerInit
        dataManager = DataManager()
        maxTide = 6.0
        minTide = -1.0 //offset this somehow to be 0?
        maxTide = maxTide - minTide
        super.init(frame:frame)
        drawTideLine(tideInit: 5)
        drawDirectionPoint(angleDeg: 90, scale: 1)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //Mark: - DatumViewPresenter Methods
    func rotateAccordingToAngle(angle: Double) {
        //don't do anything?
    }
    
    func updateAccordingToLocation(loc: CLLocation) {
        //ask data manager for new data?
    }
    
    func updateAccodringToTime(hour : Int) {
        print(String(hour))
        let futureRequest = DataRequest(withDate: Date.init(timeIntervalSinceNow: Double(hour)*60.0*60.0), andLocation: container.location, forReceiver: self)
        dataManager.getTideForecast(withRequest: futureRequest)
    }
    
    func hide() {
        self.isHidden=true
    }
    
    func show() {
        self.isHidden = false
    }
    
    //Mark: - Drawing
    func drawTideLine(tideInit : Double) {
        let theta = asin((tideInit - (maxTide/2.0))/(maxTide/2.0))
        
        print("theta = " + String(theta*180.0/Double.pi) + "for tideInit = " + String(tideInit))
        //        let theta = Double.pi/8
        let aDrawer = Drawer()
        aDrawer.drawCircleInFill(toView: self, forCenter: CGPoint(x: self.frame.size.width/2, y: self.frame.size.height/2), forRadius: self.frame.size.width/2, andColor: UIColor.blue, andStartAngle : theta)
    }
    
    func drawDirectionPoint(angleDeg:Double, scale:Double){
        let aDrawer = Drawer()
        let aView = UIView(frame: self.frame)
        self.addSubview(aView)
        aDrawer.drawTriangle(toView: aView, forCenter: self.center,forRadius:self.frame.size.width/2 + 15, forLength: 10, andColor: UIColor.red)
        aView.transform = CGAffineTransform(rotationAngle: CGFloat(angleDeg/180.0*Double.pi))
    }
    
    //MARK: DataManagerReceiver Delegate Methods
    func windForecastReceived(withData arr: [WindPacket]?, fromRequest request: DataRequest, andError error: Error?) {
    }
    
    func swellForecastReceived(withData arr: [SwellPacket]?, fromRequest request: DataRequest, andError error: Error?) {
        
    }
    
    func tideForecastReceived(withData arr: [TidePacket]?, fromRequest request: DataRequest, andError error: Error?) {
        //do something crazy
        if(arr != nil && arr!.count > 0)
        {
            let tide = arr![0].tideFt! - minTide
            drawTideLine(tideInit: tide)
        }
    }
    
    func tempForecastReceived(withData arr: [WaterTempPacket]?, fromRequest request: DataRequest, andError error: Error?) {
        
    }
    
    func wait(fromRequest request: DataRequest) {
        
    }
    
    
}
