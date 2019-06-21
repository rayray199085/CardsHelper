//
//  SCCardsSelectionOptionCell.swift
//  CardsHelper
//
//  Created by Stephen Cao on 20/6/19.
//  Copyright © 2019 Stephencao Cao. All rights reserved.
//

import UIKit

class SCCardsSelectionOptionCell: UITableViewCell {
    
    @IBOutlet weak var selectionButton: UIButton!
    var titleName: String?{
        didSet{
            guard let categoryName = titleName else{
                return
            }
            selectionButton.titleLabel?.numberOfLines = 0
            selectionButton.titleLabel?.font = UIFont(name: "OPTIBelwe-Medium", size: 14)
            selectionButton.setTitle(categoryName, for: [])
        }
    }
    var detailsItem: SCCardsDetailsItem?
    var selectedParam: [String: String]?{
        var param :[String: String]?
        if let order = detailsItem?.order{
            param = [String: String]()
            param?["order"] = order
        }
        guard let category = detailsItem?.category,
            let slug = detailsItem?.slug else{
                return param
        }
        if param == nil{
            return [category: slug]
        }
        param?[category] = slug
        return param
    }
    func selectedSelectionButton(){
        selectionButton.isSelected = true
    }
    func resetSelectionButton(){
        selectionButton.isSelected = false
    }
}
