//
//  ReportView.swift
//  SurfCaster
//
//  Created by Dylan Shackelford on 11/13/18.
//  Copyright © 2018 Dylan Shackelford. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import SwiftRangeSlider

class ReportView : UITableView, UITableViewDelegate,UITableViewDataSource {
    
    var location : CLLocation?
    var rangeSlider : RangeSlider?
    
    override init(frame: CGRect, style: UITableView.Style) {

        super.init(frame: frame, style: style)
        
        location = CLLocation(latitude: 32, longitude: -117)
        
        self.delegate = self
        self.dataSource = self
        
        let nib = UINib(nibName: "TextInputCell", bundle: Bundle.main)
        self.register(nib, forCellReuseIdentifier: "TextInputCellReuseIdentifier")
        
        let slidernib = UINib(nibName: "SliderCell", bundle: Bundle.main)
        self.register(slidernib, forCellReuseIdentifier: "SliderCellReuseIdentifier")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //I know a location
    //grab nearest spot data for swell/wind direction
    //fill in
    //ask user for time of session
    
    //MARK: - UITableViewDelegate Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if(indexPath.row == 0)
        {
            let aCell = self.dequeueReusableCell(withIdentifier: "TextInputCellReuseIdentifier") as! TextInputCell
            aCell.textLabel?.text = "Spot:"
            aCell.textInput?.text = "Bitach ass"
            return aCell
        }
        else if(indexPath.row == 1)
        {
            let aCell = self.dequeueReusableCell(withIdentifier: "SliderCellReuseIdentifier") as! SliderCell
//            aCell.textLabel?.text = "dood:"
            aCell.rangeSlider.minimumValue = 0
            aCell.rangeSlider.maximumValue = 10
            aCell.rangeSlider.lowerValue = 1
            aCell.rangeSlider.upperValue = 8
            
            aCell.rangeSlider .addTarget(self, action: #selector(ReportView.rangeSliderValueChange), for: UIControl.Event.valueChanged)
            self.rangeSlider = aCell.rangeSlider
            return aCell
        }
        else
        {
            let aCell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "resuseIdentifier")
            aCell.textLabel?.text = "Surf Details"
            return aCell
        }
        
    }
    
    @objc func rangeSliderValueChange(){
        print("value found to be: " + String(self.rangeSlider!.upperValue) + " While also being " + String(self.rangeSlider!.lowerValue))
    }
}
