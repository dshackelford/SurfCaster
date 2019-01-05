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
class WindDatumPresenter : UIView, DatumViewPresenter, DataManagerReceiver{

    var infoLabel : UILabel
    var angleOffset : Double
    var dataManager : DataManager
    var container : DatumViewContainer

    init(frame: CGRect, andContainer containerInit:DatumViewContainer) {
        infoLabel = UILabel(frame: frame)
        angleOffset = 0.0
        dataManager = DataManager()
        container = containerInit
        
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
        let dataRequest = DataRequest(withDate: Date.init(timeIntervalSinceNow: 0), andLocation: loc, forReceiver: self)
        dataManager.getWindForecast(withReqest: dataRequest)
    }

    func updateAccodringToTime(hour : Int) {
        
        let futureRequest = DataRequest(withDate: Date.init(timeIntervalSinceNow: Double(hour)*60.0*60.0), andLocation: container.location, forReceiver: self)
        dataManager.getWindForecast(withReqest: futureRequest)
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
    

    //MARK: DataManagerReceiver Delegate Methods
    func windForecastReceived(withData arr: [WindPacket]?, fromRequest request: DataRequest, andError error: Error?) {
        if(arr != nil && error == nil)
        {
            for packet in arr!
            {
                if(packet.directionCompass != nil && packet.directionDegrees != nil && packet.hour != nil)
                {
                   print("Wind direction: " + packet.directionCompass! + " and degrees: " + String(packet.directionDegrees!) + " at hour: " + packet.hour!)
                }
            }
            
            DispatchQueue.main.async {
                self.infoLabel.text = arr![0].directionCompass
                self.angleOffset = arr![0].directionDegrees! + 180
            }
        }
    }
    
    func swellForecastReceived(withData arr: [WindPacket]?, fromRequest request: DataRequest, andError error: Error?) {
        
    }
    
    func tideForecastReceived(withData arr: [WindPacket]?, fromRequest request: DataRequest, andError error: Error?) {
        
    }
    
    func tempForecastReceived(withData arr: [WindPacket]?, fromRequest request: DataRequest, andError error: Error?) {
        
    }
    
    func wait(fromRequest request: DataRequest) {
        
    }
    
}
