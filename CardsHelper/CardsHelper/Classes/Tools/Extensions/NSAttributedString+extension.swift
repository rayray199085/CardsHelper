//
//  NSAttributedString+extension.swift
//  SinaWeibo
//
//  Created by Stephen Cao on 9/5/19.
//  Copyright © 2019 Stephen Cao. All rights reserved.
//

import Foundation
import Atributika

extension NSAttributedString{
    
    /// calculate label height accroding to label size
    ///
    /// - Parameter size: label size
    /// - Returns: label height
    func getTextHeight(size: CGSize)->CGFloat{
        return boundingRect(
            with: size,
            options:
            [NSStringDrawingOptions.usesLineFragmentOrigin],
            context: nil).height
    }
    
    static func getDescriptionAttributedText(flavorText: String?, htmlString: String?) -> NSAttributedString {
        let cardDescription = NSMutableAttributedString(string: "")
    
        guard let flavorText = flavorText,
            let des = htmlString else{
            return cardDescription
        }
        let flavorItalic = Style("i").font(.italicSystemFont(ofSize: 13)).foregroundColor(HelperCommonValues.SCNaviBarTintColor)
        let rest = Style.font(.systemFont(ofSize: 13)).foregroundColor(HelperCommonValues.SCBaseViewBackgroundColor)
        cardDescription.append(flavorText.style(tags: [flavorItalic]).styleAll(rest).attributedString)
        
        cardDescription.append(NSAttributedString(string: "\n"))
        
        let bold = Style("b").font(.boldSystemFont(ofSize: 13)).foregroundColor(.green)
        let italic = Style("i").font(.italicSystemFont(ofSize: 13)).foregroundColor(.orange)
        let all = Style.font(.systemFont(ofSize: 12)).foregroundColor(UIColor.white)
        cardDescription.append(des.style(tags: [bold,italic]).styleAll(all).attributedString)
        return cardDescription
    }
}
