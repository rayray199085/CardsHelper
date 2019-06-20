//
//  SCMetadataSetGroup.swift
//  CardsHelper
//
//  Created by Stephen Cao on 20/6/19.
//  Copyright © 2019 Stephencao Cao. All rights reserved.
//

import UIKit

class SCMetadataSetGroup: SCMetadataBase {
    @objc var year: Int = 0
    @objc var cardSets: [String]?
    @objc var standard: Int = 0
    @objc var icon: String?
    
    override var description: String{
        return yy_modelDescription()
    }
}
