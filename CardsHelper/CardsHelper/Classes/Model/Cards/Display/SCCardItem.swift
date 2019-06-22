//
//  SCCardItem.swift
//  CardsHelper
//
//  Created by Stephen Cao on 21/6/19.
//  Copyright © 2019 Stephencao Cao. All rights reserved.
//

import UIKit

class SCCardItem: NSObject {
    @objc var artistName: String?
    @objc var cardSetId: Int = 0
    @objc var cardSetName: String?
    @objc var cardTypeId: Int = 0
    @objc var cardTypeName: String?
    @objc var classId: Int = 0
    @objc var cardClassName: String?
    @objc var collectible: Int = 0
    @objc var flavorText: String?
    @objc var id: Int = 0
    @objc var image: String?
    @objc var cardImage: UIImage?
    @objc var manaCost: Int = 0
    @objc var name: String?
    @objc var rarityId: Int = 0
    @objc var cardRarityName: String?
    @objc var slug: String?
    @objc var text: String?
    
    override var description: String{
        return yy_modelDescription()
    }
}
