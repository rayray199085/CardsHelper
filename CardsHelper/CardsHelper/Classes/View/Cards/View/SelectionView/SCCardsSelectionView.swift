//
//  SCCardsSelectionView.swift
//  CardsHelper
//
//  Created by Stephen Cao on 19/6/19.
//  Copyright © 2019 Stephencao Cao. All rights reserved.
//

import UIKit
import SVProgressHUD
protocol SCCardsSelectionViewDelegate: NSObjectProtocol {
    func didSelectCardsProperties(view: SCCardsSelectionView?, params: [String: String])
}
private let selectionReuseId = "selection_cell"
private let detailsReuseId = "details_cell"
class SCCardsSelectionView: UIView {
    weak var delegate: SCCardsSelectionViewDelegate?
    private var categories: [[String: Any?]]?
    private var detailsItems:[SCCardsDetailsItem]?{
        didSet{
            detailsTableView.reloadData()
            detailsTableView.scroll(to: UITableView.scrollsTo.top, animated: true)
        }
    }

    var viewModel: SCCardsViewModel?{
        didSet{
            SVProgressHUD.show()
            viewModel?.loadMetadata(completion: { [weak self](isSuccess) in
                SVProgressHUD.dismiss()
                self?.categories = self?.viewModel?.categoryNames
                self?.selectionTableView.reloadData()
            })
        }
    }

    class func cardsSelectionView()->SCCardsSelectionView{
        let nib = UINib(nibName: "SCCardsSelectionView", bundle: nil)
        let v = nib.instantiate(withOwner: self, options: nil)[0] as! SCCardsSelectionView
        v.frame = UIScreen.main.bounds
        return v
    }
    
    override func awakeFromNib() {
        selectionTableView.delegate = self
        selectionTableView.dataSource = self
        selectionTableView.register(UINib(nibName: "SCCardsSelectionOptionCell", bundle: nil), forCellReuseIdentifier: selectionReuseId)
        selectionTableView.rowHeight = 52
        selectionTableView.separatorStyle = .none
        
        detailsTableView.delegate = self
        detailsTableView.dataSource = self
        detailsTableView.register(UINib(nibName: "SCCardsSelectionDetailsCell", bundle: nil), forCellReuseIdentifier: detailsReuseId)
        detailsTableView.rowHeight = 52
        detailsTableView.separatorStyle = .none
        
        textField.returnKeyType = .search
        textField.delegate = self
    }
    
    
    @IBOutlet weak var manaButtonsView: SCCardsManaView!
    @IBOutlet weak var detailsTableView: UITableView!
    @IBOutlet weak var selectionTableView: UITableView!
    @IBOutlet weak var textField: UITextField!
    
    @IBAction func clickSelectionMaskButton(_ sender: Any) {
        shrinkSelectionView { [weak self](params) in
            self?.delegate?.didSelectCardsProperties(view: self, params: params)
        }
    }
    
    
    @IBAction func clickResetButton(_ sender: Any) {
        for row in 0..<selectionTableView.numberOfRows(inSection: 0){
            let cell = selectionTableView.cellForRow(at: IndexPath(row: row, section: 0)) as? SCCardsSelectionOptionCell
            cell?.titleName = categories?[row]["name"] as? String
            cell?.resetSelectionButton()
            cell?.detailsItem = nil
        }
        detailsItems?.removeAll()
        manaButtonsView.clearAllSelectedButtons()
        textField.text?.removeAll()
    }
}
extension SCCardsSelectionView: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == selectionTableView{
            return categories?.count ?? 0
        }else if tableView == detailsTableView{
            return detailsItems?.count ?? 0
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == selectionTableView{
            let cell = tableView.dequeueReusableCell(withIdentifier: selectionReuseId, for: indexPath) as! SCCardsSelectionOptionCell
            cell.titleName = categories?[indexPath.row]["name"] as? String
            return cell
        }else if tableView == detailsTableView{
            let cell = tableView.dequeueReusableCell(withIdentifier: detailsReuseId, for: indexPath) as! SCCardsSelectionDetailsCell
            cell.detailsItem = detailsItems?[indexPath.row]
            return cell
        }
        return UITableViewCell()
       
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == selectionTableView{
            for index in 0..<tableView.numberOfRows(inSection: 0){
                (tableView.cellForRow(at: IndexPath(item: index, section: 0)) as? SCCardsSelectionOptionCell)?.resetSelectionButton()
            }
            let cell = tableView.cellForRow(at: indexPath) as? SCCardsSelectionOptionCell
            cell?.selectedSelectionButton()
            detailsItems = categories?[indexPath.row]["category"] as? [SCCardsDetailsItem]
        }else if tableView == detailsTableView{
            let cell = tableView.cellForRow(at: indexPath) as? SCCardsSelectionDetailsCell
            
            guard let row = selectionTableView.indexPathForSelectedRow,
                let selectionCell = selectionTableView.cellForRow(at: row) as? SCCardsSelectionOptionCell else{
                    return
            }
            selectionCell.titleName = cell?.name
            selectionCell.detailsItem = cell?.detailsItem
        }
    }
}
extension SCCardsSelectionView: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
}

extension SCCardsSelectionView{
    func expandSelectionView(completion: @escaping ()->()){
        addPopHorizontalAnimation(fromValue: -UIScreen.screenWidth() / 2, toValue: UIScreen.screenWidth() / 2, springBounciness: 6, springSpeed: 12, delay: 0) { (_, _) in
            completion()
        }
    }
    func shrinkSelectionView(completion:@escaping (_ params: [String: String])->()){
        textField.resignFirstResponder()
        addPopHorizontalAnimation(fromValue: UIScreen.screenWidth() / 2, toValue: -UIScreen.screenWidth() / 2, springBounciness: 6, springSpeed: 12, delay: 0) { [unowned self](_, _) in
            var params = [String: String]()
            if let manaParam = self.manaButtonsView.selectedButtonsValueParam{
                params.merge(manaParam, uniquingKeysWith: { (current, _) in current })
            }
            for row in 0..<self.selectionTableView.numberOfRows(inSection: 0){
                let cell = self.selectionTableView.cellForRow(at: IndexPath(row: row, section: 0)) as? SCCardsSelectionOptionCell
                guard let param = cell?.selectedParam else{
                    continue
                }
                params.merge(param, uniquingKeysWith: { (current, _) in current })
            }
            if self.textField.hasText{
                params["textFilter"] = self.textField.text
            }
            completion(params)
        }
    }
}
