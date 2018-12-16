//
//  WindDatumPresenter.swift
//  SurfCaster
//
//  Created by Dylan Shackelford on 12/1/18.
//  Copyright © 2018 Dylan Shackelford. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
class WindDatumPresenter : UIView, DatumViewPresenter, SpitCastDataDelegate{

    var infoLabel : UILabel
    var angleOffset : Double
    var forecast : [WindPacket]

    override init(frame: CGRect) {
        infoLabel = UILabel(frame: frame)
        angleOffset = 0.0
        forecast = Array<WindPacket>()
        super.init(frame:frame)
        drawDirectionPoint(angleDeg: 0, scale: 1)
        self.addSubview(infoLabel)
        infoLabel.text = "75°"
        infoLabel.textAlignment = NSTextAlignment.center
        infoLabel.font = UIFont.boldSystemFont(ofSize: 80)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    //Mark: - DatumViewPresenter Methods
    func rotateAccordingToAngle(angle: Double) {
        self.transform = CGAffineTransform(rotationAngle: CGFloat(-angle/180.0*Double.pi) + CGFloat(-angleOffset/180.0*Double.pi))
        infoLabel.transform = CGAffineTransform(rotationAngle: CGFloat(angle/180.0*Double.pi) + CGFloat(angleOffset/180.0*Double.pi))
    }

    func updateAccordingToLocation(loc: CLLocation) {
        let dataManager = DataManager()
        dataManager.getWindForecast(forLocation: loc, andDate: Date.init(timeIntervalSinceNow: 0) as NSDate, andReceiver: self)
//        dataManager.getWind
        //ask data manager for new data?
    }

    func updateAccodringToTime(hour : Int) {
        if(hour < forecast.count)
        {
            angleOffset = forecast[hour].directionDegrees + 180
            rotateAccordingToAngle(angle: 0)
        }
    }
    
    func hide() {
        self.isHidden=true
    }
    
    func show() {
        self.isHidden = false
    }


    //Mark: - Drawing
    func drawDirectionPoint(angleDeg:Double, scale:Double){
        let aDrawer = Drawer()
        aDrawer.drawTriangle(toView: self, forCenter: self.center,forRadius:self.frame.size.width/2 + 15, forLength: 10, andColor: UIColor.red)
    }
    
    //MARK: SpitCastDelegateMethods
    func foundTempData(data: WaterTempPacket?, county: String, error: Error?) {
        
    }
    
    func foundTideData(dataArr: [TidePacket]?, county: String, error: Error?) {
        
    }
    
    func foundSwellData(dataArr: [SwellPacket]?, county: String, error: Error?) {
        
    }
    
    func foundWindData(dataArr: [WindPacket]?, county: String, error: Error?) {
        if(dataArr != nil)
        {
            for packet in dataArr!
            {
                print("Wind direction: " + packet.directionCompass + " and degrees: " + String(packet.directionDegrees) + " at hour: " + packet.hour)
            }
            
            forecast = dataArr!
            
            DispatchQueue.main.async {
                self.infoLabel.text = dataArr![0].directionCompass
                self.angleOffset = dataArr![0].directionDegrees + 180
            }
        }
    }
    
    func foundAllSpots(dataArr: [SpotPacket]?, error: Error?) {
        
    }
}
