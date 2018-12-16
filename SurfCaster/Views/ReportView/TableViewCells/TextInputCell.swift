//
//  TextInputCell.swift
//  SurfCaster
//
//  Created by Dylan Shackelford on 12/8/18.
//  Copyright © 2018 Dylan Shackelford. All rights reserved.
//

import Foundation
import UIKit

class TextInputCell : UITableViewCell{
    
    @IBOutlet var textInput : UITextField?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    
}
