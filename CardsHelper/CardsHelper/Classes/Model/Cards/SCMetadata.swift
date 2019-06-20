//
//  SCMetadata.swift
//  CardsHelper
//
//  Created by Stephen Cao on 20/6/19.
//  Copyright © 2019 Stephencao Cao. All rights reserved.
//

import UIKit

class SCMetadata: NSObject {
    @objc var sets: [SCMetadataSet]?
    @objc var setGroups: [SCMetadataSetGroup]?
    @objc var types: [SCMetadataType]?
    @objc var rarities: [SCMetadataRarity]?
    @objc var classes: [SCMetadaClass]?
    @objc var minionTypes: [SCMetadataMinionType]?
    @objc var keywords: [SCMetadataKeyword]?
    @objc var filterableFields: [String]?
    @objc var numericFields: [String]?

    @objc class func modelContainerPropertyGenericClass()->[String:AnyClass]{
        return ["sets": SCMetadataSet.self,
                "setGroups": SCMetadataSetGroup.self,
                "types": SCMetadataType.self,
                "rarities": SCMetadataRarity.self,
                "classes":SCMetadaClass.self,
                "minionTypes":SCMetadataMinionType.self,
                "keywords": SCMetadataKeyword.self]
    }
    override var description: String{
        return yy_modelDescription()
    }
}
