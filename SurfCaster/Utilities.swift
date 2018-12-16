//
//  Utilities.swift
//  SurfCaster
//
//  Created by Dylan Shackelford on 12/2/18.
//  Copyright © 2018 Dylan Shackelford. All rights reserved.
//

import Foundation

class FileUtilities : NSObject{
    
    class func getDocsPath()->String{
        return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
    }
}

