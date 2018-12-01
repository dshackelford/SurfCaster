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

class DatumView : UIView{
    
    var vc : ViewController?
    var screenSize : CGSize
    var panGesture : UIPanGestureRecognizer
    var pointerView : UIView
    
    init(withVC vcInit :ViewController){
        vc = vcInit
        screenSize = UIScreen.main.bounds.size
        
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
        
        panGesture = UIPanGestureRecognizer()
        pointerView = UIView(frame: CGRect(x: 0, y: 0, width: myFrame.width, height: myFrame.height))
        
        super.init(frame: myFrame)
        
        panGesture.addTarget(self, action:#selector(DatumView.handlePan))
        self.addGestureRecognizer(panGesture)
        vcInit.view.addSubview(self)
        self.addSubview(pointerView)
        
        drawTideLine(tideInit: 100)
        
        drawDirectionPoint(angleDeg: 10, scale: 1)
    }
    
    @objc func handlePan(recognizer:UIPanGestureRecognizer){
//        print("long press")
        let translation = recognizer.translation(in: self)
        
        self.center = CGPoint(x: self.center.x + translation.x, y: self.center.y + translation.y)
        
        recognizer.setTranslation(CGPoint.zero, in: self)
        print(self.frame.origin.x)
        UserDefaults.standard.set(self.frame.origin.x, forKey: "DatumOriginX")
        UserDefaults.standard.set(self.frame.origin.y, forKey: "DatumOriginY")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func headingChanged(heading:Double)
    {
        pointerView.transform = CGAffineTransform(rotationAngle: CGFloat(-heading/180.0*Double.pi))
    }
    
    
    func drawTideLine(tideInit : Double) {
        // theta = invTan(x/r)
        let maxTide = 200.0
//        let minTide = 0.0
        let theta = asin((tideInit - (maxTide/2.0))/(maxTide/2.0))

        print("theta = " + String(theta*180.0/Double.pi))
//        let theta = Double.pi/8
        let aDrawer = Drawer()
        aDrawer.drawCircleInFill(toView: self, forCenter: CGPoint(x: self.frame.size.width/2, y: self.frame.size.height/2), forRadius: self.frame.size.width/2, andColor: UIColor.blue, andStartAngle : theta)
        aDrawer.drawCircle(toView: self, forCenter: CGPoint(x: self.frame.size.width/2, y: self.frame.size.height/2), andRadius: self.frame.size.width/2, andColor: UIColor.black)
        
    }
    
    func drawDirectionPoint(angleDeg:Double, scale:Double){
        let aDrawer = Drawer()
        aDrawer.drawTriangle(toView: pointerView, forCenter: self.center,forRadius:self.frame.size.width/2 + 15, forLength: 10, andColor: UIColor.red, andStartAngle: 0)
    }
    
}
