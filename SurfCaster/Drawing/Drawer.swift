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
    
    func drawTriangle(toView view :UIView, forCenter point:CGPoint, forRadius radius: CGFloat, forLength length: CGFloat, andColor color:UIColor, andStartAngle startAngle: Double) {
        
        let path = UIBezierPath()
        let center = CGPoint(x:view.frame.size.width/2, y: view.frame.size.height/2)
        path.move(to: CGPoint(x:center.x + radius,y:center.y))
        path.addLine(to: CGPoint(x:center.x + radius + length,y:center.y - length/2))
        path.addLine(to: CGPoint(x:center.x + radius + length,y:center.y + length/2))
//        path.addLine(to: CGPoint(x:center.x + 100,y:center.y))
        path.close()
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        
        //change the fill color
        shapeLayer.fillColor = color.cgColor
        //you can change the stroke color
        shapeLayer.strokeColor = UIColor.red.cgColor
        //you can change the line width
        shapeLayer.lineWidth = 8.0
        
        view.layer.addSublayer(shapeLayer)
    }
}
