//
//  SCMetadataKeyword.swift
//  CardsHelper
//
//  Created by Stephen Cao on 20/6/19.
//  Copyright © 2019 Stephencao Cao. All rights reserved.
//

import UIKit

class SCMetadataKeyword: SCMetadataBase {
    @objc var id: Int = 0
    @objc var refText: String?
    @objc var text: String?
    
    override var description: String{
        return yy_modelDescription()
    }
}
