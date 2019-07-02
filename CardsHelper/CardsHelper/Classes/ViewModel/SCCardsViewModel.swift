//
//  SCCardsViewModel.swift
//  CardsHelper
//
//  Created by Stephen Cao on 20/6/19.
//  Copyright © 2019 Stephencao Cao. All rights reserved.
//

import Foundation

class SCCardsViewModel: SCBaseViewModel{
    var categoryNames: [[String: Any?]]?
    
    var cards: [SCCardItem] = [SCCardItem]()
    var cardsInfo: SCCardsInfo?{
        didSet{
            cards.removeAll()
            cards = cardsInfo?.cards ?? []
        }
    }
    
    override var metadata: SCMetadata?{
        didSet{
            let setCategory = getCategories(defaultText: "All Cards", metaDataBase: metadata?.sets)
            let classCategory = getCategories(defaultText: "All Classes", metaDataBase: metadata?.classes)
            let typeCategory = getCategories(defaultText: "Any Type", metaDataBase: metadata?.types)
            let rarityCategory = getCategories(defaultText: "Any Rarity", metaDataBase: metadata?.rarities)
            let minionTypeCategory = getCategories(defaultText: "Any Type", metaDataBase: metadata?.minionTypes)
            let keywordCategory = getCategories(defaultText: "Any Keyword", metaDataBase: metadata?.keywords)
            let attackCategory = getValueCategories(text: "Attack", startLocation: 0, count: 11, defaultText: "Any Attack")
            let healthCategory = getValueCategories(text: "Health", startLocation: 1, count: 10, defaultText: "Any Health")
            let sortByCategory = getSortByCategory()
            
            categoryNames = [["name": "All Cards", "category": setCategory],
                            ["name":  "All Classes", "category": classCategory],
                            ["name": "Attack", "category": attackCategory],
                            ["name":  "Health", "category": healthCategory],
                            ["name": "Card Type", "category": typeCategory],
                            ["name": "Rarity", "category": rarityCategory],
                            ["name": "Minion Type", "category": minionTypeCategory],
                            ["name": "Keywords", "category": keywordCategory],
                            ["name":"Sort By","category": sortByCategory]]
        }
    }
}
private extension SCCardsViewModel{
    func getCategories(defaultText: String, metaDataBase: [SCMetadataBase]?)->[SCCardsDetailsItem]{
        var array = [SCCardsDetailsItem]()
        if defaultText != "All Classes" && defaultText != "All Cards"{
            array.append(SCCardsDetailsItem(name: defaultText))
        }
        if defaultText == "All Cards"{
            array.append(SCCardsDetailsItem(name: "All Cards", slug: "wild", category: "set"))
            array.append(SCCardsDetailsItem(name: "Standard Cards", slug: "standard", category: "set"))
        }
        for base in metaDataBase ?? []{
            array.append(SCCardsDetailsItem(name: base.name, slug: base.slug, category: base.category))
        }
        return array
    }
    func getValueCategories(text: String,startLocation: Int, count: Int, defaultText: String)->[SCCardsDetailsItem]{
        var array = [SCCardsDetailsItem]()
        var count = count
        count += startLocation
        
        array.append(SCCardsDetailsItem(name: defaultText, category: text.lowercased()))
        for index in startLocation..<count{
            let item = SCCardsDetailsItem(category: text.lowercased())
            if index == count - 1{
                item.slug = "\(index)^"
                item.name = "\(text):\(index)+"
            }else{
                item.slug = "\(index)"
                item.name = "\(text):\(index)"
            }
            array.append(item)
        }
        return array
    }
    func getSortByCategory()->[SCCardsDetailsItem]{
        let array = [
        SCCardsDetailsItem(name: "Mana: low to high", category: "sort"),
        SCCardsDetailsItem(name: "Mana: high to low", category: "sort", order: "desc"),
        SCCardsDetailsItem(name: "Card Name: A to Z", slug: "name", category: "sort"),
        SCCardsDetailsItem(name: "Card Name: Z to A", slug: "name", category: "sort", order: "desc"),
        SCCardsDetailsItem(name: "Attack: low to high", slug: "attack", category: "sort"),
        SCCardsDetailsItem(name: "Attack: high to low", slug: "attack", category: "sort", order: "desc"),
        SCCardsDetailsItem(name: "Health: low to high", slug: "health", category: "sort"),
        SCCardsDetailsItem(name: "Health: high to low", slug: "health", category: "sort", order: "desc")]
        return array
    }
}
extension SCCardsViewModel{
    func loadCards(params: [String: String], completion:@escaping (_ isSuccess: Bool)->()){
        SCNetworkManager.shared.getCards(params: params) { (dict, isSuccess) in
            if !isSuccess{
                completion(false)
                return
            }
            guard let dict = dict else{
                completion(false)
                return
            }
            self.cardsInfo = SCCardsInfo.yy_model(with: dict)
            let group = DispatchGroup()
            for card in self.cardsInfo?.cards ?? []{
                guard let imageUrlString = card.image else{
                    continue
                }
                group.enter()
                SCNetworkManager.shared.getCardImage(imageUrlString: imageUrlString, completion: { (image) in
                    card.cardImage = image
                    group.leave()
                })
            }
            group.notify(queue: DispatchQueue.main, execute: {
                for card in self.cards{
                    self.setCardCategoryName(card: card)
                    self.getCardCraftingCostAndDustValue(card: card)
                }
                completion(isSuccess)
            })
        }
    }
    func clearStoredCards(){
        cards.removeAll()
    }
}
