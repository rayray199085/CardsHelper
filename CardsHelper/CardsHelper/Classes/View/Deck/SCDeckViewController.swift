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
    // for avoiding loading same content
    private var prevDeckCode: String?
    
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
        navigationItem.rightBarButtonItem?.isEnabled = false
        addDeckCodeView.addPopAlphaAnimation(fromValue: 0.0, toValue: 1.0, duration: 0.25) { [weak self](_, _) in
            self?.addDeckCodeView.isHidden = false
            self?.navigationItem.rightBarButtonItem?.isEnabled = true
        }
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
        navigationItem.rightBarButtonItem?.isEnabled = false
        addDeckCodeView.addPopAlphaAnimation(fromValue: 1.0, toValue: 0.0, duration: 0.25) { [weak self](_, _) in
            self?.addDeckCodeView.isHidden = true
            self?.navigationItem.rightBarButtonItem?.isEnabled = true
            if self?.prevDeckCode == deckCode{
                completion(false)
                self?.addDeckCodeView.clearAllInput()
                return
            }
            if doesBothFieldFilled{
                SVProgressHUD.show()
                self?.viewModel?.loadDeckData(with: deckCode, region: region, completion: { (isSuccess) in
                    if !isSuccess{
                        SVProgressHUD.showInfo(withStatus: "Invalid deck code, please check your input again.")
                        completion(false)
                        return
                    }
                    self?.viewMoreCards()
                    completion(isSuccess)
                    self?.prevDeckCode = deckCode
                    self?.statsView.chartData = self?.viewModel?.chartData
                    SVProgressHUD.dismiss()
                })
            }
            else if !doesBothFieldFilled && deckCode != ""{
                SVProgressHUD.showInfo(withStatus: "Nickname might be helpful to locate deck code.")
            }
        }
    }
}
extension SCDeckViewController: SCCardsDisplayViewDelegate{
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
