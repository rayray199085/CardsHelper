//
//  SCDeckViewController.swift
//  CardsHelper
//
//  Created by Stephen Cao on 18/6/19.
//  Copyright © 2019 Stephencao Cao. All rights reserved.
//

import UIKit
import SVProgressHUD

class SCDeckViewController: SCBaseViewController {
    private lazy var imageMaskView = SCCardsMaskView.cardsMaskView()
    private lazy var displayView = SCCardsDisplayView.displayView()
    private lazy var statsView = SCDeckStatsView.statsView()
    private lazy var addDeckCodeView:SCDeckAddDeckCodeView = {
        let v =  SCDeckAddDeckCodeView.addDeckCodeView()
        v.readDeckCode()
        return v
    }()
    
    private var viewModel: SCDeckViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func setupUserView() {
        super.setupUserView()
        viewModel = SCDeckViewModel()
        loadMetadata()
        setupDisplayView()
        setupStatsView()
        setupAddDecodeView()
        setupMaskView()
    }
    @objc private func clickStatsButton(){
        navigationItem.leftBarButtonItem?.isEnabled = false
        if statsView.frame.origin.y == -UIScreen.screenHeight(){
            statsView.expandStatsView {[weak self] in
                self?.navigationItem.leftBarButtonItem?.isEnabled = true
            }
        }else{
            statsView.shrinkStatsView {[weak self] in
                self?.navigationItem.leftBarButtonItem?.isEnabled = true
            }
        }
    }
    @objc private func clickAddButton(){
        addDeckCodeView.isHidden = false
    }
}
private extension SCDeckViewController{
    func setupMaskView(){
        tabBarController?.view.addSubview(imageMaskView)
        imageMaskView.isHidden = true
        imageMaskView.delegate = self
    }
    
    func setupDisplayView(){
        view.addSubview(displayView)
        displayView.delegate = self
        displayView.tableViewTopCons.constant = 5
    }
    
    func loadMetadata(){
        SVProgressHUD.show()
        viewModel?.loadMetadata(completion: {(_) in
            SVProgressHUD.dismiss()
        })
    }
    func setupStatsView(){
        view.addSubview(statsView)
        statsView.frame.origin.y = -UIScreen.screenHeight()
        setupNavigationItem()
    }
    func setupNavigationItem(){
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Stats", fontSize: 16, target: self, action: #selector(clickStatsButton), isBack: false)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(clickAddButton))
    }
    func setupAddDecodeView(){
        tabBarController?.view.addSubview(addDeckCodeView)
        addDeckCodeView.isHidden = true
        addDeckCodeView.delegate = self
    }
}
extension SCDeckViewController: SCDeckAddDeckCodeViewDelegate{
    func didClickDeckMaskButton(view: SCDeckAddDeckCodeView, region: String, deckCode: String?, doesBothFieldFilled: Bool, completion: @escaping (Bool) -> ()) {
        addDeckCodeView.isHidden = true
        if doesBothFieldFilled{
            SVProgressHUD.show()
            viewModel?.loadDeckData(with: deckCode, region: region, completion: { [weak self](isSuccess) in
                self?.viewMoreCards()
                completion(isSuccess)
                SVProgressHUD.dismiss()
            })
        }
        else if deckCode == ""{
            
        }
        else{
           SVProgressHUD.showInfo(withStatus: "Nickname might be helpful to locate deck code.")
        }
    }
}
extension SCDeckViewController: SCCardsDisplayViewDelegate{
    func didClickPrevButton(view: SCCardsDisplayView) {
        
    }
    
    func didClickNextButton(view: SCCardsDisplayView) {
        
    }
    
    func didSelectCell(view: SCCardsDisplayView, centerPoint: CGPoint, image: UIImage?) {
        imageMaskView.isHidden = false
        imageMaskView.setImage(centerPoint: centerPoint, image: image)
    }
}
extension SCDeckViewController: SCCardsMaskViewDelegate{
    func didClickImageMaskButton(view: SCCardsMaskView?) {
        imageMaskView.isHidden = true
    }
}
private extension SCDeckViewController{
    func viewMoreCards(){
        guard let array = viewModel?.deckData?.cards else{
            return
        }
        displayView.cards = array
        displayView.tableView.scroll(to: UITableView.scrollsTo.top, animated: true)
    }
}
