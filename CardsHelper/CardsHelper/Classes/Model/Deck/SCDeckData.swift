//
//  SCDeckData.swift
//  CardsHelper
//
//  Created by Stephen Cao on 23/6/19.
//  Copyright © 2019 Stephencao Cao. All rights reserved.
//

import UIKit

class SCDeckData: NSObject {
    @objc var version: Int = 0
    @objc var format: String?
    @objc var hero: SCCardItem?
    @objc var cardClass:SCMetadaClass?
    @objc var cards: [SCCardItem]?
    @objc var cardCount: Int = 0
    
    @objc class func modelContainerPropertyGenericClass()->[String:AnyClass]{
        return ["cards": SCCardItem.self]
    }
    @objc class func modelCustomPropertyMapper()->[String:String]{
        return ["cardClass": "class"]
    }
    override var description: String{
        return yy_modelDescription()
    }
}
