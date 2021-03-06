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

/**
 Handles all `UIBezierPath` calls.
 Mainly used by `Datum`'s.
 */
class Drawer : NSObject{
    
    ///Draws a cropped circle, see `TideDatumPresenter`.
    func drawPartialCircle(toView view : UIView, forCenter point:CGPoint, andRadius radius:CGFloat, andAngle angle: Double, andColor color: UIColor) ->CAShapeLayer{
        
        let circlePath = UIBezierPath(arcCenter: point, radius: radius, startAngle: CGFloat(0), endAngle:CGFloat(angle), clockwise: true)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.cgPath
        
        //change the fill color
        shapeLayer.fillColor = UIColor.clear.cgColor
        //you can change the stroke color
        shapeLayer.strokeColor = color.cgColor
        //you can change the line width
        shapeLayer.lineWidth = 4.0
        
        view.layer.addSublayer(shapeLayer)
        
        return shapeLayer
    }
    
    ///Draws a full circle for all `Datum`'s circle ring.
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
    
    ///Fills in a cropped circle for tide filling.
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
    
    
    ///`Datum`'s indicator triangle.
    func drawTriangle(toView view :UIView, forCenter point:CGPoint, forRadius radius: CGFloat, forLength length: CGFloat, andColor color:UIColor) {
        
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
        shapeLayer.strokeColor = color.cgColor
        //you can change the line width
        shapeLayer.lineWidth = 8.0
        
        view.layer.addSublayer(shapeLayer)
    }
}
