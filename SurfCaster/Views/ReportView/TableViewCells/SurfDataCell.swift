//
//  SurfDataCell.swift
//  SurfCaster
//
//  Created by Dylan Shackelford on 11/13/18.
//  Copyright © 2018 Dylan Shackelford. All rights reserved.
//

import Foundation
import UIKit

class SurfDataCell : UITableViewCell{
    
    @IBOutlet var mainLabel : UILabel?
    @IBOutlet var dataLabel : UILabel?
    @IBOutlet var imageIconView : UIImageView?
    
//    init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
////        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        super.init(coder: <#T##NSCoder#>)
//        mainLabel?.text = "important"
//        dataLabel?.text = "6m/s"
//
//    }
//
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
