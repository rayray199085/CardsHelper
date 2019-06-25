//
//  SCCardsManaView.swift
//  CardsHelper
//
//  Created by Stephen Cao on 21/6/19.
//  Copyright © 2019 Stephencao Cao. All rights reserved.
//

import UIKit

class SCCardsManaView: UIStackView {

    var selectedButtonsValueParam: [String: String]?{
        var values = ""
        for btn in manaButtons{
            if btn.isSelected{
                guard var contentValue = btn.titleLabel?.text else{
                    continue
                }
                contentValue = contentValue == "10" ? "10^" : contentValue
                values += "\(contentValue),"
            }
        }
        if (values as NSString).hasSuffix(","){
            values.removeLast()
        }
        if values.count == 0{
            return nil
        }
        return ["manaCost": values]
    }
    @IBOutlet var manaButtons: [UIButton]!
    
    @IBAction func clickManaButton(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    func clearAllSelectedButtons(){
        for btn in manaButtons{
            btn.isSelected = false
        }
    }
}
