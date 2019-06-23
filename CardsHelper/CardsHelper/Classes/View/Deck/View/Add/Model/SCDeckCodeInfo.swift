//
//  SCDeckCodeInfo.swift
//  CardsHelper
//
//  Created by Stephen Cao on 23/6/19.
//  Copyright © 2019 Stephencao Cao. All rights reserved.
//

import UIKit

class SCDeckCodeInfo: NSObject {
    @objc var nickname: String?
    @objc var deckCode: String?
    @objc var region: String?
    @objc var loginCount: Int = 0
    
    func setInfo(nickname: String, deckCode: String, region: String){
        self.nickname = nickname
        self.deckCode = deckCode
        self.region = region
        loginCount += 1
    }
}
