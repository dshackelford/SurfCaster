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

class TideDatumPresenter: UIView , DatumViewPresenter {
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        drawTideLine(tideInit: 100)
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
        //ask data manager for new data?
    }
    
    func hide() {
        self.isHidden=true
    }
    
    func show() {
        self.isHidden = false
    }
    
    //Mark: - Drawing
    func drawTideLine(tideInit : Double) {
        // theta = invTan(x/r)
        let maxTide = 200.0
        //        let minTide = 0.0
        let theta = asin((tideInit - (maxTide/2.0))/(maxTide/2.0))
        
        print("theta = " + String(theta*180.0/Double.pi))
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
}
