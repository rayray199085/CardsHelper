//
//  SCMetadaClass.swift
//  CardsHelper
//
//  Created by Stephen Cao on 20/6/19.
//  Copyright © 2019 Stephencao Cao. All rights reserved.
//

import UIKit

class SCMetadaClass: SCMetadataBase {
    @objc var id: Int = 0
    override var category: String{
        return "class"
    }
    override var description: String{
        return yy_modelDescription()
    }
}
