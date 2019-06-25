//
//  SCDeckAddDeckCodeView.swift
//  CardsHelper
//
//  Created by Stephen Cao on 23/6/19.
//  Copyright © 2019 Stephencao Cao. All rights reserved.
//

import UIKit
private let fileName = "deckCodeRecords.json"
private let reuseIdentifier = "code_cell"

protocol SCDeckAddDeckCodeViewDelegate: NSObjectProtocol {
    func didClickDeckMaskButton(view: SCDeckAddDeckCodeView, region: String, deckCode: String?,doesBothFieldFilled: Bool, completion:@escaping (_ isSuccess: Bool)->())
}
class SCDeckAddDeckCodeView: UIView {
    weak var delegate: SCDeckAddDeckCodeViewDelegate?
    private var records = [SCDeckCodeInfo]()
    
    class func addDeckCodeView()->SCDeckAddDeckCodeView{
        let nib = UINib(nibName: "SCDeckAddDeckCodeView", bundle: nil)
        let v = nib.instantiate(withOwner: self, options: nil)[0] as! SCDeckAddDeckCodeView
        v.frame = UIScreen.main.bounds
        return v
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        setupTableView()
        nicknameTextField.addTarget(self, action: #selector(textFieldDidChange), for: UIControl.Event.editingChanged)
        deckCodeTextField.addTarget(self, action: #selector(textFieldDidChange), for: UIControl.Event.editingChanged)
    }
    @objc private func textFieldDidChange(){
        bothFieldFillSignal.isHidden = !(nicknameTextField.hasText && deckCodeTextField.hasText)
    }
    
    @IBAction func clickResetButton(_ sender: Any) {
        clearAllInput()
    }
    
    
    @IBOutlet weak var bothFieldFillSignal: UIButton!
    @IBOutlet weak var segmentControl: UISegmentedControl!

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var deckCodeTextField: UITextField!
    @IBOutlet weak var nicknameTextField: UITextField!
    
    @IBAction func clickDeckMaskButton(_ sender: Any) {
        deckCodeTextField.resignFirstResponder()
        nicknameTextField.resignFirstResponder()
        
        let region = segmentControl.titleForSegment(at: segmentControl.selectedSegmentIndex)
        delegate?.didClickDeckMaskButton(
            view: self,
            region: region ?? "us",
            deckCode: deckCodeTextField.text,
            doesBothFieldFilled: !bothFieldFillSignal.isHidden,
            completion: { [weak self](isSuccess) in
            if isSuccess{
                guard let deckCode = self?.deckCodeTextField.text,
                    let region = region?.lowercased(),
                    let nickname = self?.nicknameTextField.text else{
                        return
                }
                if deckCode == "" || nickname == ""{
                    return
                }
                let res = self?.records.filter({ (rec) -> Bool in
                    return rec.deckCode == deckCode && rec.region == region && rec.nickname == nickname
                })
                let newRec: SCDeckCodeInfo
                if (res?.count ?? 0) > 0{
                    newRec = res![0]
                    newRec.loginCount += 1
                    self?.records.removeAll(where: { (rec) -> Bool in
                        return rec == newRec
                    })
                }else{
                    newRec = SCDeckCodeInfo()
                    newRec.setInfo(nickname: nickname, deckCode: deckCode, region: region)
                }
                self?.records.insert(newRec, at: 0)
                self?.saveDeckCode()
                self?.clearAllInput()
                self?.tableView.reloadData()
            }
        })
    }
    func clearAllInput(){
        nicknameTextField.text?.removeAll()
        deckCodeTextField.text?.removeAll()
        segmentControl.selectedSegmentIndex = 0
        textFieldDidChange()
    }
}
private extension SCDeckAddDeckCodeView{
    func setupTableView(){
        tableView.separatorStyle = .none
        tableView.register(UINib(nibName: "SCDeckCodeTableViewCell", bundle: nil), forCellReuseIdentifier: reuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 90
    }
}
extension SCDeckAddDeckCodeView: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return records.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! SCDeckCodeTableViewCell
        cell.deckCodeInfo = records[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        nicknameTextField.text = records[indexPath.row].nickname
        deckCodeTextField.text = records[indexPath.row].deckCode
        switch records[indexPath.row].region {
        case "us":
            segmentControl.selectedSegmentIndex = 0
        case "eu":
            segmentControl.selectedSegmentIndex = 1
        case "apac":
            segmentControl.selectedSegmentIndex = 2
        default:
            break
        }
        textFieldDidChange()
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            records.remove(at: indexPath.row)
            saveDeckCode()
            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.fade)
        }
    }
}

extension SCDeckAddDeckCodeView{
    private func saveDeckCode(){
        var array =  [[String: Any]]()
        for rec in records{
            guard let dict = rec.yy_modelToJSONObject() as? [String: Any] else{
                continue
            }
            array.append(dict)
        }
        guard let data = try? JSONSerialization.data(withJSONObject: array, options: []) else{
            return
        }
        try? data.write(to: URL(fileURLWithPath: NSString.getDocumentDirectory().appendingPathComponent(fileName)))
    }
    
    func readDeckCode(){
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: NSString.getDocumentDirectory().appendingPathComponent(fileName))),
            let array = try? JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] else {
                return
        }
        records.removeAll()
        for dict in array{
            guard let rec = SCDeckCodeInfo.yy_model(with: dict) else{
                continue
            }
            records.append(rec)
        }
        records.sort { (rec0, rec1) -> Bool in
            return rec0.loginCount > rec1.loginCount
        }
        tableView.reloadData()
    }
}
