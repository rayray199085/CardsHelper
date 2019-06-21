//
//  SCCardsViewController.swift
//  CardsHelper
//
//  Created by Stephen Cao on 18/6/19.
//  Copyright © 2019 Stephencao Cao. All rights reserved.
//

import UIKit
import SVProgressHUD

class SCCardsViewController: SCBaseViewController {
    private lazy var cardsView = SCCardsSelectionView.cardsSelectionView()
    private lazy var displayView = SCCardsDisplayView.displayView()
    private var prevParams: [String: String]?
    private var currentPage = 1{
        didSet{
           updateDisplayViewContent()
        }
    }
    private var viewModel: SCCardsViewModel?
    private var params: [String: String]?{
        didSet{
            if prevParams == params{
                return
            }
            prevParams = nil
            currentPage = 1
            viewModel?.clearStoredCards()
            loadMoreCards()
        }
    }
    func loadMoreCards(){
        var params = self.params
        if prevParams == nil{
            prevParams = params
        }
        params?["page"] = "\(currentPage)"
        SVProgressHUD.show()
        viewModel?.loadCards(params: params!, completion: { [weak self](_) in
            SVProgressHUD.dismiss()
            self?.updateDisplayViewContent()
            print(self?.viewModel?.cards.count ?? 0)
        })
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func setupUserView() {
        super.setupUserView()
        viewModel = SCCardsViewModel()
        setupDisplayView()
        setupSelectionView()
    }
    @objc private func clickSearchButton(){
        navigationItem.leftBarButtonItem?.isEnabled = false
        if cardsView.frame.origin.x == -UIScreen.screenWidth(){
            cardsView.expandSelectionView {[weak self] in
                self?.navigationItem.leftBarButtonItem?.isEnabled = true
            }
        }else{
            cardsView.shrinkSelectionView { [weak self](params) in
                self?.navigationItem.leftBarButtonItem?.isEnabled = true
                self?.params = params
            }
        }
    }
}
private extension SCCardsViewController{
    func setupSelectionView(){
        cardsView.delegate = self
        cardsView.viewModel = viewModel
        view.addSubview(cardsView)
        cardsView.frame.origin.x = -UIScreen.screenWidth()
        setupNavigationButton()
    }
    func setupNavigationButton(){
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.search, target: self, action: #selector(clickSearchButton))
    }
    func setupDisplayView(){
        view.addSubview(displayView)
        displayView.delegate = self
    }
}
extension SCCardsViewController: SCCardsSelectionViewDelegate{
    func didSelectCardsProperties(view: SCCardsSelectionView?, params: [String : String]) {
        self.params = params
    }
}
extension SCCardsViewController: SCCardsDisplayViewDelegate{
    func didClickPrevButton(view: SCCardsDisplayView) {
        if currentPage <= 1{
            return
        }
        currentPage -= 1
    }
    
    func didClickNextButton(view: SCCardsDisplayView) {
        if currentPage >= viewModel?.cardsInfo?.pageCount ?? 0{
            return
        }
        currentPage += 1
        if currentPage * 40 <= viewModel?.cards.count ?? 0{
            
        }else{
            loadMoreCards()
        }
    }
}
private extension SCCardsViewController{
    func updateDisplayViewContent(){
        guard let pageCount = viewModel?.cardsInfo?.pageCount else {
            return
        }
        displayView.pageCountLabel.text = pageCount > 1 ? "\(currentPage) / \(pageCount)" : ""
        displayView.updateDirectionButtonDisplay(currentPage: currentPage, pageCount: pageCount)
    }
}
