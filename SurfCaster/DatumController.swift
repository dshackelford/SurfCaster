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

class DatumController{
    
    var vc : ViewController?
    var screenSize : CGSize
    
    init(withVC vcInit :ViewController){
        vc = vcInit
        screenSize = UIScreen.main.bounds.size
    }
    
    
    func drawTideLine(tideInit : Double) {
        // theta = invTan(x/r)
        let maxTide = 200.0
//        let minTide = 0.0
        let theta = asin((tideInit - (maxTide/2.0))/(maxTide/2.0))
//        if(tideInit >= maxTide)
//        {
//            theta = Double.pi/2;
//        }
//        else if(tideInit <= minTide)
//        {
//            theta = -Double.pi/2
//        }
//        else
//        {
//            theta = atan((tideInit - (maxTide/2.0))/(maxTide/2.0))
//        }

        print("theta = " + String(theta*180.0/Double.pi))
//        let theta = Double.pi/8
        let aDrawer = Drawer()
        aDrawer.drawCircleInFill(toView: vc!.view, forCenter: CGPoint(x: screenSize.width/2, y: screenSize.height/2), forRadius: 100, andColor: UIColor.blue, andStartAngle : theta)
        aDrawer.drawCircle(toView: vc!.view, forCenter: CGPoint(x: screenSize.width/2, y: screenSize.height/2), andRadius: 100, andColor: UIColor.black)
        
    }
    
//    func draw(){
//        let aDrawer = Drawer()
//        aDrawer.drawCircleInFill(toView: vc!.view, forCenter: CGPoint(x: screenSize.width/2, y: screenSize.height/2), forRadius: 100, andColor: UIColor.blue)
//        aDrawer.drawCircle(toView: vc!.view, forCenter: CGPoint(x: screenSize.width/2, y: screenSize.height/2), andRadius: 100, andColor: UIColor.black)
//    }
    
}
