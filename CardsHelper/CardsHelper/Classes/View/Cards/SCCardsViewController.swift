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
    private var viewModel: SCCardsViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func setupUserView() {
        super.setupUserView()
        viewModel = SCCardsViewModel()
        setupSelectionView()
    }
    @objc private func clickSearchButton(){
        navigationItem.leftBarButtonItem?.isEnabled = false
        if cardsView.frame.origin.x == -UIScreen.screenWidth(){
            cardsView.addPopHorizontalAnimation(fromValue: -UIScreen.screenWidth() / 2, toValue: UIScreen.screenWidth() / 2, springBounciness: 6, springSpeed: 12, delay: 0) { [unowned self](_, _) in
                self.navigationItem.leftBarButtonItem?.isEnabled = true
            }
        }else{
            cardsView.addPopHorizontalAnimation(fromValue: UIScreen.screenWidth() / 2, toValue: -UIScreen.screenWidth() / 2, springBounciness: 6, springSpeed: 12, delay: 0) { [unowned self](_, _) in
                self.navigationItem.leftBarButtonItem?.isEnabled = true
            }
        }
    }
}
private extension SCCardsViewController{
    func setupSelectionView(){
        cardsView.viewModel = viewModel
        view.addSubview(cardsView)
        cardsView.frame.origin.x = -UIScreen.screenWidth()
        setupNavigationButton()
    }
    func setupNavigationButton(){
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.search, target: self, action: #selector(clickSearchButton))
    }
}
