//
//  ViewController.swift
//  SurfCaster
//
//  Created by Dylan Shackelford on 11/13/18.
//  Copyright © 2018 Dylan Shackelford. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController {
    var aMapView : MapView?
    var locationManager : LocationManager?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let screenSize = UIScreen.main.bounds.size
        
        aMapView = MapView(vc: self, frame: CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height))
        self.view.addSubview(aMapView!)
        
        locationManager = LocationManager(vc: self)
        // Do any additional setup after loading the view, typically from a nib.
        
        let aDatumController = DatumController(withVC: self)
        aDatumController.drawTideLine(tideInit: 85)
    }

    @IBAction func onReportButton(){
        print("show report!")
        let aReportView = ReportView.init(frame: CGRect(x: 0, y: 20, width: 200, height: 300))
        self.view.addSubview(aReportView)
    }
    
    @IBAction func onForecastButton(){
        print("show Forecast");
    }
    
    
}

