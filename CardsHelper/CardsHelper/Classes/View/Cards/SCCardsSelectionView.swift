//
//  SCCardsSelectionView.swift
//  CardsHelper
//
//  Created by Stephen Cao on 19/6/19.
//  Copyright © 2019 Stephencao Cao. All rights reserved.
//

import UIKit

class SCCardsSelectionView: UIView {

    class func cardsSelectionView()->SCCardsSelectionView{
        let nib = UINib(nibName: "SCCardsSelectionView", bundle: nil)
        let v = nib.instantiate(withOwner: self, options: nil)[0] as! SCCardsSelectionView
        v.frame = UIScreen.main.bounds
        return v
    }

}
