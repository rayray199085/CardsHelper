//
//  SCBaseViewModel.swift
//  CardsHelper
//
//  Created by Stephen Cao on 23/6/19.
//  Copyright © 2019 Stephencao Cao. All rights reserved.
//

import Foundation

class SCBaseViewModel{
    var metadata: SCMetadata?
    // used for finding category name from category id
    func loadMetadata(completion: @escaping (_ isSuccess: Bool)->()){
        SCNetworkManager.shared.getMetadata { (dict, isSuccess) in
            if !isSuccess{
                completion(false)
                return
            }
            guard let dict = dict,
                let metadata = SCMetadata.yy_model(with: dict) else{
                    completion(false)
                    return
            }
            for rarity in metadata.rarities ?? []{
                guard let cost = rarity.craftingCost,
                      let value = rarity.dustValue else{
                    continue
                }
                if cost[0].isKind(of: NSNull.self){
                    rarity.craftingCost = nil
                }
                if value[0].isKind(of: NSNull.self){
                    rarity.dustValue = nil
                }
            }
            self.metadata = metadata
            completion(isSuccess)
        }
    }
    func findCategoryNameFromId(array: [SCMetadataBase]?,targetId: Int)->String?{
        let res = array?.filter({ (base) -> Bool in
            return base.id == targetId
        })
        return res?.count ?? 0 > 0 ? res?[0].name : nil
    }
    func setCardCategoryName(card: SCCardItem){
        card.cardClassName = findCategoryNameFromId(array: metadata?.classes, targetId: card.classId)
        card.cardTypeName = findCategoryNameFromId(array: metadata?.types, targetId: card.cardTypeId)
        card.cardSetName = findCategoryNameFromId(array: metadata?.sets, targetId: card.cardSetId)
        card.cardRarityName = findCategoryNameFromId(array: metadata?.rarities, targetId: card.rarityId)
    }
    
    func getCardCraftingCostAndDustValue(card: SCCardItem){
        let res = metadata?.rarities?.filter({ (rarity) -> Bool in
            return rarity.id == card.rarityId
        })
        if res?.count ?? 0 > 0{
            card.cardCraftingCost = res?[0].craftingCost
            card.cardDustValue = res?[0].dustValue
        }
    }
}
