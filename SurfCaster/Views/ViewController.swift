//
//  ViewController.swift
//  SurfCaster
//
//  Created by Dylan Shackelford on 11/13/18.
//  Copyright © 2018 Dylan Shackelford. All rights reserved.
//

import UIKit
import MapKit

/**
 Main View Controller holding the `MapView` and `ReportView`. 
 */
class ViewController: UIViewController {
    var aMapView : MapView?
    var locationManager : LocationManager?
    var reportView : ReportView?
    var mapViewButton : UIButton?
    var reportButton : UIButton?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileUtilities.getDocsPath())
        let screenSize = UIScreen.main.bounds.size
        
        reportView = ReportView(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height - 35))
        self.view.addSubview(reportView!)
        reportView?.isHidden = true
        
        
        aMapView = MapView(vc: self, frame: CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height))
        self.view.addSubview(aMapView!)
        
        addButtons()
        
        locationManager = LocationManager()
    }
    
    func addButtons(){
        let screenSize = UIScreen.main.bounds.size
        reportButton = UIButton(frame: CGRect(x: screenSize.width/2, y: screenSize.height - 35, width: screenSize.width/2, height: 35))
        reportButton?.backgroundColor = UIColor.white.withAlphaComponent(0.8)
        reportButton?.setImage(UIImage(named: "newspaper.png"), for: UIControl.State.normal)
        reportButton?.imageView?.contentMode = .scaleAspectFit
        self.view.addSubview(reportButton!)
        reportButton?.addTarget(self, action: #selector(ViewController.onReportButton), for: UIControl.Event.touchUpInside)
        
        mapViewButton = UIButton(frame: CGRect(x: 0, y: screenSize.height - 35, width: screenSize.width/2, height: 35))
        mapViewButton?.backgroundColor = UIColor.white.withAlphaComponent(0.6)
        mapViewButton?.setImage(UIImage(named: "compassRed.png"), for: UIControl.State.normal)
        mapViewButton?.imageView?.contentMode = .scaleAspectFit
        self.view.addSubview(mapViewButton!)
        mapViewButton?.addTarget(self, action: #selector(ViewController.onMapButton), for: UIControl.Event.touchUpInside)
    }
    
    ///Makes the `ReportView` the main view.
    @objc func onReportButton(){
        self.aMapView?.isHidden = true
        self.reportView?.isHidden = false
        
    }
    
    
    ///Makes the `MapView` the main view.
    @objc func onMapButton(){
        self.aMapView?.isHidden = false
        self.reportView?.isHidden = true
    }
    
}

