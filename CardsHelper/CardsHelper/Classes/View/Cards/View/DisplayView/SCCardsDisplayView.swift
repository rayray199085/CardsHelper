//
//  SCCardsDisplayView.swift
//  CardsHelper
//
//  Created by Stephen Cao on 21/6/19.
//  Copyright © 2019 Stephencao Cao. All rights reserved.
//

import UIKit
protocol SCCardsDisplayViewDelegate: NSObjectProtocol {
    func didClickPrevButton(view: SCCardsDisplayView)
    func didClickNextButton(view: SCCardsDisplayView)
}
class SCCardsDisplayView: UIView {
    weak var delegate: SCCardsDisplayViewDelegate?
    
    class func displayView()->SCCardsDisplayView{
        let nib = UINib(nibName: "SCCardsDisplayView", bundle: nil)
        let v = nib.instantiate(withOwner: self, options: nil)[0] as! SCCardsDisplayView
        v.frame = UIScreen.main.bounds
        for btn in v.directionButtons{
            btn.isHidden = true
        }
        return v
    }
    
    func updateDirectionButtonDisplay(currentPage: Int, pageCount: Int) {
        if currentPage == 1{
            directionButtons.first?.isHidden = true
            directionButtons.last?.isHidden = false
        }else if currentPage == pageCount{
            directionButtons.first?.isHidden = false
            directionButtons.last?.isHidden = true
        }else{
            directionButtons.first?.isHidden = false
            directionButtons.last?.isHidden = false
        }
    }
    
    @IBOutlet var directionButtons: [UIButton]!
    
    @IBOutlet weak var pageCountLabel: UILabel!
    
    
    @IBAction func clickPrevPageButton(_ sender: UIButton) {
        delegate?.didClickPrevButton(view: self)
    }
    @IBAction func clickNextPageButton(_ sender: UIButton) {
        delegate?.didClickNextButton(view: self)
    }
}
