//
//  SliderCell.swift
//  SurfCaster
//
//  Created by Dylan Shackelford on 12/9/18.
//  Copyright © 2018 Dylan Shackelford. All rights reserved.
//

import Foundation
import UIKit
import SwiftRangeSlider

class SliderCell : UITableViewCell{
    
    @IBOutlet weak var rangeSlider : RangeSlider!
    @IBOutlet weak var startTimeLabel : UILabel?
    @IBOutlet weak var endTimeLabel : UILabel?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
