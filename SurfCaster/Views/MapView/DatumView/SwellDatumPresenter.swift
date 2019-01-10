//
//  SwellDatumPresenter.swift
//  SurfCaster
//
//  Created by Dylan Shackelford on 12/1/18.
//  Copyright © 2018 Dylan Shackelford. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

/**
 `Datum` presenting the Swell Data.
 Info label will desribe the current water temperature.
 Rings oscillating inside the circle ring indicate the period of the swell.
 Indicator triangles (as many as swells for the current hour) will scale relative to weight of swell.
 */
class SwellDatumPresenter : UIView, DatumViewPresenter{
    
    var infoLabel : UILabel
    var periodCircle : CAShapeLayer?
    var periodAngle : Double
    var periodView : UIView
    var container : DatumViewContainer
    
    init(frame: CGRect, andContainer containerInit:DatumViewContainer) {
        periodAngle = 0
        periodView = UIView(frame: frame)
        infoLabel = UILabel(frame: frame)
        
        container = containerInit
        
        super.init(frame:frame)
        self.addSubview(periodView)
        
        infoLabel.text = "68°"
        infoLabel.textAlignment = NSTextAlignment.center
        infoLabel.font = UIFont.boldSystemFont(ofSize: 80)
        self.addSubview(infoLabel)
        
        drawDirectionPoint(angleDeg: 0, scale: 1)
        startPeriodTimer()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //Mark: - DatumViewPresenter Methods
    func rotateAccordingToAngle(angle: Double) {
        self.transform = CGAffineTransform(rotationAngle: CGFloat(-angle/180.0*Double.pi))
        infoLabel.transform = CGAffineTransform(rotationAngle: CGFloat(angle/180.0*Double.pi))
    }
    
    func updateAccordingToLocation(loc: CLLocation) {
        //ask data manager for new data?
    }
    
    func updateAccodringToTime(hour : Int) {
        //ask data manager for new data?
    }
    
    func hide() {
        self.isHidden=true
    }
    
    func show() {
        self.isHidden = false
    }
    
    //Mark: - Drawing
    func startPeriodTimer(){
        Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { (timer) in
            
            let period : Double = 1.0//seconds
            let frameRate : Double = 1.0/40.0
            let stepRad = (Double.pi*2.0)/period*frameRate
            self.periodAngle = self.periodAngle + stepRad
            if(self.periodAngle > 2.0*Double.pi)
            {
                self.periodAngle = 0
            }
            self.animateSwellPeriod(forAngle: self.periodAngle)
        }
    }
    
    func animateSwellPeriod(forAngle angle:Double){
        if(periodCircle != nil)
        {
            periodCircle!.removeFromSuperlayer()
        }
        
        let aDrawer = Drawer()
        periodCircle = aDrawer.drawPartialCircle(toView: periodView, forCenter: CGPoint(x: periodView.frame.size.width/2, y: periodView.frame.size.height/2), andRadius: periodView.frame.size.width/2 - 8, andAngle: angle, andColor: UIColor.green)
    }
    
    
    func drawDirectionPoint(angleDeg:Double, scale:Double){
        let aDrawer = Drawer()
        aDrawer.drawTriangle(toView: self, forCenter: self.center,forRadius:self.frame.size.width/2 + 15, forLength: 10, andColor: UIColor.red)
        
        let aView = UIView(frame:self.frame)
        self.addSubview(aView)
        aDrawer.drawTriangle(toView: aView, forCenter: self.center,forRadius:self.frame.size.width/2 + 15, forLength: 10, andColor: UIColor.purple)
        aView.transform = CGAffineTransform(rotationAngle: CGFloat(285/180.0*Double.pi))
    }
    
    //MARK: DataManagerReceiver Delegate Methods
    func windForecastReceived(withData arr: [WindPacket]?, fromRequest request: DataRequest, andError error: Error?) {
    }
    
    func swellForecastReceived(withData arr: [SwellPacket]?, fromRequest request: DataRequest, andError error: Error?) {
        
    }
    
    func tideForecastReceived(withData arr: [TidePacket]?, fromRequest request: DataRequest, andError error: Error?) {
        
    }
    
    func tempForecastReceived(withData arr: [WaterTempPacket]?, fromRequest request: DataRequest, andError error: Error?) {
        
    }
    
    func wait(fromRequest request: DataRequest) {
        
    }
}
