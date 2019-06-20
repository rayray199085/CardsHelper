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
    var categoryName: String?{
        didSet{
            selectionButton.titleLabel?.numberOfLines = 0
            selectionButton.titleLabel?.font = UIFont(name: "OPTIBelwe-Medium", size: 14)
            selectionButton.setTitle(categoryName, for: [])
        }
    }
    func selectedSelectionButton(){
        selectionButton.isSelected = true
    }
    func resetSelectionButton(){
        selectionButton.isSelected = false
    }
}
