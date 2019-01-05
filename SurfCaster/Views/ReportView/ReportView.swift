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
        
        let ratingNib = UINib(nibName: "RatingCell", bundle: Bundle.main)
        self.register(ratingNib, forCellReuseIdentifier: "RatingCellReuseIdentifier")
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
        switch section {
        case 0:
            return 1 //spot name input
        case 1:
            return 1 //time range slider
        case 2:
            return 3 //swell/wind/tide
        case 3:
            return 1 //notes text field
        case 4:
            return 2 //star rating and save button
        default:
            return 1
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Spot"
        case 1:
            return "Session"
        case 2:
            return "Details"
        case 3:
            return "Notes"
        case 4:
            return "Rating"
        default:
            return "Report"
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 30
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 50
        case 1:
            return 70
        case 2:
            return 60
        case 3:
            return 80
        case 4:
            return 40
        default:
            return 30
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            let aCell = self.dequeueReusableCell(withIdentifier: "TextInputCellReuseIdentifier") as! TextInputCell
            aCell.textInput?.text = "Garbage Boils"
            return aCell
        case 1:
            let aCell = self.dequeueReusableCell(withIdentifier: "SliderCellReuseIdentifier") as! SliderCell
            aCell.rangeSlider.minimumValue = 0
            aCell.rangeSlider.maximumValue = 10
            aCell.rangeSlider.lowerValue = 1
            aCell.rangeSlider.upperValue = 8
            
            aCell.rangeSlider .addTarget(self, action: #selector(ReportView.rangeSliderValueChange), for: UIControl.Event.valueChanged)
            self.rangeSlider = aCell.rangeSlider
            return aCell
        case 2:
            let aCell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "resuseIdentifier")
            if(indexPath.row == 0)
            {
                aCell.textLabel?.text = "Swell"
            }
            else if(indexPath.row == 1)
            {
                aCell.textLabel?.text = "Wind"
            }
            else
            {
                aCell.textLabel?.text = "Tide"
            }
            //gotta grab some data some how to fill in a mini graph?
            return aCell
        case 3:
            let aCell = self.dequeueReusableCell(withIdentifier: "TextInputCellReuseIdentifier") as! TextInputCell
            aCell.textInput?.text = "Coming off the boil for that left triangle"
            return aCell
        case 4:
            if(indexPath.row == 0)
            {
                let aCell = self.dequeueReusableCell(withIdentifier: "RatingCellReuseIdentifier") as! RatingCell
                return aCell
            }
        default:
            let aCell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "resuseIdentifier")
            aCell.textLabel?.text = "Surf Details"
            return aCell
        }
        
        let aCell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "resuseIdentifier")
        aCell.textLabel?.text = "Surf Details"
        return aCell
    }
    
    @objc func rangeSliderValueChange(){
        //grab some old data to show on the cells and for saving
        print("value found to be: " + String(self.rangeSlider!.upperValue) + " While also being " + String(self.rangeSlider!.lowerValue))
    }
}
