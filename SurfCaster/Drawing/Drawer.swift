//
//  Drawer.swift
//  SurfCaster
//
//  Created by Dylan Shackelford on 11/14/18.
//  Copyright © 2018 Dylan Shackelford. All rights reserved.
//

import Foundation
import UIKit
import CoreGraphics

class Drawer : NSObject{
    
    func drawCircle(toView view : UIView, forCenter point:CGPoint, andRadius radius:CGFloat, andColor color: UIColor){
        
        let circlePath = UIBezierPath(arcCenter: point, radius: radius, startAngle: CGFloat(0), endAngle:CGFloat(Double.pi * 2), clockwise: true)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.cgPath
        
        //change the fill color
        shapeLayer.fillColor = UIColor.clear.cgColor
        //you can change the stroke color
        shapeLayer.strokeColor = color.cgColor
        //you can change the line width
        shapeLayer.lineWidth = 8.0
        
        view.layer.addSublayer(shapeLayer)
    }
    
    func drawCircleInFill(toView view :UIView, forCenter point:CGPoint, forRadius radius: CGFloat, andColor color:UIColor, andStartAngle startAngle: Double) {
        
        let circlePath = UIBezierPath(arcCenter: point, radius: radius - 4, startAngle: CGFloat(-startAngle), endAngle:CGFloat(Double.pi+startAngle), clockwise: true)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.cgPath
        
        //change the fill color
        shapeLayer.fillColor = color.cgColor
        //you can change the stroke color
        shapeLayer.strokeColor = UIColor.clear.cgColor
        //you can change the line width
        shapeLayer.lineWidth = 8.0
        
        view.layer.addSublayer(shapeLayer)
    }
}
