//
//  SCMetadataBase.swift
//  CardsHelper
//
//  Created by Stephen Cao on 20/6/19.
//  Copyright © 2019 Stephencao Cao. All rights reserved.
//

import UIKit

class SCMetadataBase: NSObject {
    @objc var slug: String?
    @objc var name: String?
    @objc var id: Int = 0
    
    var category: String{
        return ""
    }
}
