//
//  SCCardsDisplayView.swift
//  CardsHelper
//
//  Created by Stephen Cao on 21/6/19.
//  Copyright © 2019 Stephencao Cao. All rights reserved.
//

import UIKit
private let reuseIdentifer = "card_cell"
protocol SCCardsDisplayViewDelegate: NSObjectProtocol {
    func didClickPrevButton(view: SCCardsDisplayView)
    func didClickNextButton(view: SCCardsDisplayView)
    func didSelectCell(view: SCCardsDisplayView, centerPoint: CGPoint, image: UIImage?)
}
class SCCardsDisplayView: UIView {
    var cards: [SCCardItem]?{
        didSet{
            tableView.reloadData()
        }
    }
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
            directionButtons.last?.isHidden = pageCount <= 1
        }else if currentPage == pageCount{
            directionButtons.first?.isHidden = false
            directionButtons.last?.isHidden = true
        }else{
            directionButtons.first?.isHidden = false
            directionButtons.last?.isHidden = false
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "SCCardTableViewCell", bundle: nil), forCellReuseIdentifier: reuseIdentifer)
        tableView.rowHeight = 199
        tableView.separatorStyle = .none
    }
    
    @IBOutlet var directionButtons: [UIButton]!
    @IBOutlet weak var pageCountLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func clickPrevPageButton(_ sender: UIButton) {
        delegate?.didClickPrevButton(view: self)
    }
    @IBAction func clickNextPageButton(_ sender: UIButton) {
        delegate?.didClickNextButton(view: self)
    }
}
extension SCCardsDisplayView: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cards?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifer, for: indexPath) as! SCCardTableViewCell
        cell.card = cards?[indexPath.row]
        cell.setTextViewScrollToTop()
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! SCCardTableViewCell
        let imageViewCenterPoint = convert(cell.cardImageView.center, from: cell.contentView)
        delegate?.didSelectCell(view: self, centerPoint: imageViewCenterPoint, image: cards?[indexPath.row].cardImage)
    }
}
