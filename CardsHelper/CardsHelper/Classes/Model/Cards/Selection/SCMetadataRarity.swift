//
//  SCMetadataRarity.swift
//  CardsHelper
//
//  Created by Stephen Cao on 20/6/19.
//  Copyright © 2019 Stephencao Cao. All rights reserved.
//

import UIKit

class SCMetadataRarity: SCMetadataBase {
    @objc var craftingCost: [NSNumber]?
    @objc var dustValue: [NSNumber]?
    override var category: String{
        return "rarity"
    }
    override var description: String{
        return yy_modelDescription()
    }
}
