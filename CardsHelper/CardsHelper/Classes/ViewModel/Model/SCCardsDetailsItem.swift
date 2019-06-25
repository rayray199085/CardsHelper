//
//  SCCardsDetailsItem.swift
//  CardsHelper
//
//  Created by Stephen Cao on 21/6/19.
//  Copyright © 2019 Stephencao Cao. All rights reserved.
//

import UIKit

class SCCardsDetailsItem: NSObject {
    @objc var name: String?
    @objc var slug: String?
    @objc var category: String?
    @objc var order: String?
    
    init(name: String? = nil, slug: String? = nil, category: String? = nil, order: String? = nil){
        self.name = name
        self.slug = slug
        self.category = category
        self.order = order
    }
    override var description: String{
        return yy_modelDescription()
    }
}
