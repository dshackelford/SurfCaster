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

class ReportView : UIView, UITableViewDelegate,UITableViewDataSource {
    
    var tableView : UITableView?
    var location : CLLocation?
    
    override init(frame:CGRect){
        super.init(frame: frame)
        location = CLLocation(latitude: 32, longitude: -117)
        self.backgroundColor = UIColor.gray
        
        tableView = UITableView.init(frame: frame);
        tableView?.delegate = self
        tableView?.dataSource = self
        self.addSubview(tableView!)
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
        
//        let aCell = SurfDataCell()
//        aCell.loadNib()
        let aCell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "resuseIdentifier")
        return aCell
    }
}
