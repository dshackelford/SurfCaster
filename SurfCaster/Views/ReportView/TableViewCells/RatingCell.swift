//
//  RatingCell.swift
//  SurfCaster
//
//  Created by Dylan Shackelford on 12/15/18.
//  Copyright © 2018 Dylan Shackelford. All rights reserved.
//

import Foundation
import Foundation
import UIKit

class RatingCell : UITableViewCell{
    
    @IBOutlet var star1 : UIButton?
    @IBOutlet var star2 : UIButton?
    @IBOutlet var star3 : UIButton?
    @IBOutlet var star4 : UIButton?
    @IBOutlet var star5 : UIButton?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
}
