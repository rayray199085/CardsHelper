//
//  SCCardsSelectionDetailsCell.swift
//  CardsHelper
//
//  Created by Stephen Cao on 20/6/19.
//  Copyright © 2019 Stephencao Cao. All rights reserved.
//

import UIKit

class SCCardsSelectionDetailsCell: UITableViewCell {
    @IBOutlet weak var detailsButton: UIButton!
    var name: String?
    var detailsItem: SCCardsDetailsItem?{
        didSet{
            guard let title = detailsItem?.name else {
                return
            }
            detailsButton.titleLabel?.numberOfLines = 0
            detailsButton.titleLabel?.font = UIFont(name: "OPTIBelwe-Medium", size: 15)
            detailsButton.setTitle(title, for: [])
            name = title
        }
    }
    func selectedDetailsButton(){
        detailsButton.isSelected = true
    }
    func resetDetailsButton(){
        detailsButton.isSelected = false
    }
}
