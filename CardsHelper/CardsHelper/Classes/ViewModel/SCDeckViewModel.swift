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
                for card in deckData.cards ?? []{
                    // find card category name
                    self.setCardCategoryName(card: card)
                }
                if let hero = deckData.hero{
                    self.setCardCategoryName(card: hero)
                }
                self.deckData = deckData
                completion(isSuccess)
            })
        }
    }
}
