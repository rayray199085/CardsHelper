//
//  SCCardsViewModel.swift
//  CardsHelper
//
//  Created by Stephen Cao on 20/6/19.
//  Copyright © 2019 Stephencao Cao. All rights reserved.
//

import Foundation

class SCCardsViewModel{
    var categoryNames: [[String: Any?]]?
    
    var metadata: SCMetadata?{
        didSet{
            let setCategory = getCategories(defaultText: "Standard Cards", metaDataBase: metadata?.sets)
            let classCategory = getCategories(defaultText: "All Classes", metaDataBase: metadata?.classes)
            let typeCategory = getCategories(defaultText: "Any Type", metaDataBase: metadata?.types)
            let rarityCategory = getCategories(defaultText: "Any Rarity", metaDataBase: metadata?.rarities)
            let minionTypeCategory = getCategories(defaultText: "Any Type", metaDataBase: metadata?.minionTypes)
            let keywordCategory = getCategories(defaultText: "Any Keyword", metaDataBase: metadata?.keywords)
            let attackCategory = getValueCategories(text: "Attack", startLocation: 0, count: 11, defaultText: "Any Attack")
            let healthCategory = getValueCategories(text: "Health", startLocation: 1, count: 10, defaultText: "Any Health")
            
            categoryNames = [["name": "Standard Cards", "category": setCategory],
                            ["name":  "All Classes", "category": classCategory],
                            ["name": "Attack", "category": attackCategory],
                            ["name":  "Health", "category": healthCategory],
                            ["name": "Card Type", "category": typeCategory],
                            ["name": "Rarity", "category": rarityCategory],
                            ["name": "Minion Type", "category": minionTypeCategory],
                            ["name": "Keywords", "category": keywordCategory]]
        }
    }
    init() {
        
    }
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
            self.metadata = metadata
            completion(isSuccess)
        }
    }
}
private extension SCCardsViewModel{
    func getCategories(defaultText: String, metaDataBase: [SCMetadataBase]?)->[[String: String?]]{
        var array = [[String: String?]]()
        if defaultText != "All Classes"{
            array.append(["slug": "", "name": defaultText])
        }
        if defaultText == "Standard Cards"{
            array.append(["slug": "wild", "name": "All Cards"])
        }
        for base in metaDataBase ?? []{
            var dict = [String: String?]()
            dict["slug"] = base.slug
            dict["name"] = base.name
            array.append(dict)
        }
        return array
    }
    func getValueCategories(text: String,startLocation: Int, count: Int, defaultText: String)->[[String: String?]]{
        var array = [[String: String]]()
        var count = count
        count += startLocation
        array.append(["slug":"", "name": defaultText])
        for index in startLocation..<count{
            var dict = [String: String]()
            if index == count - 1{
                dict["slug"] = "\(index)+"
                dict["name"] = "\(text):\(index)+"
            }else{
                dict["slug"] = "\(index)"
                dict["name"] = "\(text):\(index)"
            }
            array.append(dict)
        }
        return array
    }
}
