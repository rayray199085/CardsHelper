//
//  SCMetadataSet.swift
//  CardsHelper
//
//  Created by Stephen Cao on 20/6/19.
//  Copyright © 2019 Stephencao Cao. All rights reserved.
//

import UIKit

class SCMetadataSet: SCMetadataBase {
    @objc var id: Int = 0
    @objc var releaseDate: String?
    @objc var collectibleCount: Int = 0
    @objc var collectibleRevealedCount: Int = 0
    @objc var nonCollectibleCount: Int = 0
    @objc var nonCollectibleRevealedCount: Int = 0
    
    override var description: String{
        return yy_modelDescription()
    }
}
