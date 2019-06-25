//
//  SCDeckCodeTableViewCell.swift
//  CardsHelper
//
//  Created by Stephen Cao on 23/6/19.
//  Copyright © 2019 Stephencao Cao. All rights reserved.
//

import UIKit

class SCDeckCodeTableViewCell: UITableViewCell {
    var deckCodeInfo: SCDeckCodeInfo?{
        didSet{
            nicknameLabel.text = deckCodeInfo?.nickname
            deckCodeLabel.text = deckCodeInfo?.deckCode
            regionLabel.text = deckCodeInfo?.region
        }
    }
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var deckCodeLabel: UILabel!
    @IBOutlet weak var regionLabel: UILabel!
}
