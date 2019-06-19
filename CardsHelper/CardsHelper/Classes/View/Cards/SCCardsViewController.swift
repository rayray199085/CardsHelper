//
//  SCCardsViewController.swift
//  CardsHelper
//
//  Created by Stephen Cao on 18/6/19.
//  Copyright © 2019 Stephencao Cao. All rights reserved.
//

import UIKit

class SCCardsViewController: SCBaseViewController {
    private lazy var cardsView = SCCardsSelectionView.cardsSelectionView()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func setupUserView() {
        super.setupUserView()
        view.addSubview(cardsView)
    }
}
