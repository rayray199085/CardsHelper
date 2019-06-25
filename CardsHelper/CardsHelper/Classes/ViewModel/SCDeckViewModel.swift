//
//  SCDeckViewModel.swift
//  CardsHelper
//
//  Created by Stephen Cao on 23/6/19.
//  Copyright © 2019 Stephencao Cao. All rights reserved.
//

import Foundation

class SCDeckViewModel: SCBaseViewModel{
    var deckData: SCDeckData?
    var chartData: SCChartData?
    
    func loadDeckData(with deckCode: String?, region: String, completion:@escaping (_ isSuccess: Bool)->()){
        guard let deckCode = deckCode else {
            completion(false)
            return
        }
        SCNetworkManager.shared.getDeckData(with: deckCode, region: region) { (dict, isSuccess) in
            if !isSuccess{
                completion(false)
                return
            }
            guard let dict = dict,
                  let deckData = SCDeckData.yy_model(with: dict) else{
                    completion(false)
                return
            }
            let group = DispatchGroup()
            // load card images
            for card in deckData.cards ?? []{
                guard let imageUrlString = card.image else{
                    continue
                }
                group.enter()
                SCNetworkManager.shared.getCardImage(imageUrlString: imageUrlString, completion: { (image) in
                    card.cardImage = image
                    group.leave()
                })
            }
            // load hero image
            if let imageUrlString = deckData.hero?.image{
                group.enter()
                SCNetworkManager.shared.getCardImage(imageUrlString: imageUrlString, completion: { (image) in
                    deckData.hero?.cardImage = image
                    group.leave()
                })
            }
            group.notify(queue: DispatchQueue.main, execute: {
                var manaArray = [0,0,0,0,0,0,0,0]
                var chartData = SCChartData()
                chartData.cardClassName = deckData.cardClass?.name
                var dustCost = 0
                for card in deckData.cards ?? []{
                    // find card category name
                    self.setCardCategoryName(card: card)
                    self.getCardCraftingCostAndDustValue(card: card)
                    dustCost += card.craftingCost[0]
                    switch card.manaCost {
                    case 0,1,2,3,4,5,6:
                        manaArray[card.manaCost] += 1
                    default:
                        manaArray[7] += 1
                        break
                    }
                    guard let typeName = card.cardTypeName else{
                        continue
                    }
                    switch typeName{
                    case "Minion":
                        chartData.minion += 1
                    case "Spell":
                        chartData.spell += 1
                    case "Weapon":
                        chartData.weapon += 1
                    case "Hero":
                        chartData.hero += 1
                    default:
                        break
                    }
                    guard let rarityName = card.cardRarityName else{
                        continue
                    }
                    switch rarityName{
                    case "Common":
                        chartData.common += 1
                    case "Free":
                        chartData.free += 1
                    case "Rare":
                        chartData.rare += 1
                    case "Epic":
                        chartData.epic += 1
                    case "Legendary":
                        chartData.legendary += 1
                    default:
                        break
                    }
                }
                chartData.manaValues = manaArray
                chartData.dustCost = dustCost
                self.chartData = chartData
                if let hero = deckData.hero{
                    self.setCardCategoryName(card: hero)
                    self.getCardCraftingCostAndDustValue(card: hero)
                }
                self.deckData = deckData
                completion(isSuccess)
            })
        }
    }
}
