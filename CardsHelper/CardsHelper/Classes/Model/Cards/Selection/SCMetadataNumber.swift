//
//  SCMetadataNumber.swift
//  CardsHelper
//
//  Created by Stephen Cao on 24/6/19.
//  Copyright © 2019 Stephencao Cao. All rights reserved.
//

import UIKit

class SCMetadataNumber: NSObject {
    
    @objc var value: NSNumber?
    
    override var description: String{
        return yy_modelDescription()
    }
}
