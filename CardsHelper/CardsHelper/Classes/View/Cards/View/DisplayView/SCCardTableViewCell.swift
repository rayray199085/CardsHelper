//
//  SCCardTableViewCell.swift
//  CardsHelper
//
//  Created by Stephen Cao on 22/6/19.
//  Copyright © 2019 Stephencao Cao. All rights reserved.
//

import UIKit

class SCCardTableViewCell: UITableViewCell {
    var card: SCCardItem?{
        didSet{
            cardImageView.image = card?.cardImage
            
            cardNameLabel.text = card?.name
            descriptionTextView.attributedText = NSAttributedString.getDescriptionAttributedText(flavorText: card?.flavorText, htmlString: card?.text)
            
            typeLabel.text = card?.cardTypeName
            rarityLabel.text = card?.cardRarityName
            setLabel.text = card?.cardSetName
            classLabel.text = card?.cardClassName
            artistLabel.text = card?.artistName
            collectibleLabel.isHidden = card?.collectible != 1
            
            if let cost = card?.craftingCost,
                let value = card?.dustValue {
                craftingCostLabel.text = cost[0] != 0 ? "\(cost[0]) / \(cost[1]) (Golden)" : "0"
                dustValueLabel.text = value[0] != 0 ? "\(value[0]) / \(value[1]) (Golden)" : "0"
            }
        }
    }
    func setTextViewScrollToTop(){
        descriptionTextView.scrollRangeToVisible(NSMakeRange(0, 0))
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        improvePerformance()
    }
    @IBOutlet weak var cardImageView: UIImageView!
    @IBOutlet weak var cardNameLabel: UILabel!
    
    @IBOutlet weak var descriptionTextView: UITextView!{
        didSet{
            descriptionTextView.textContainerInset = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 0)
        }
    }
    
    @IBOutlet weak var dustValueLabel: UILabel!
    @IBOutlet weak var craftingCostLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var rarityLabel: UILabel!
    @IBOutlet weak var setLabel: UILabel!
    
    @IBOutlet weak var classLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var collectibleLabel: UILabel!
}
