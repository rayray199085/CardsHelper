//
//  SCCardsInfo.swift
//  CardsHelper
//
//  Created by Stephen Cao on 21/6/19.
//  Copyright © 2019 Stephencao Cao. All rights reserved.
//

import UIKit

class SCCardsInfo: NSObject {
    @objc var cards: [SCCardItem]?
    @objc var cardCount: Int = 0
    @objc var page: Int = 0
    @objc var pageCount: Int = 0
    
    override var description: String{
        return yy_modelDescription()
    }
    @objc class func modelContainerPropertyGenericClass()->[String:AnyClass]{
        return ["cards": SCCardItem.self]
    }
}
