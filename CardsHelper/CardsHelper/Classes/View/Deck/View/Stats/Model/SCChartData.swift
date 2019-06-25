//
//  SCChartData.swift
//  CardsHelper
//
//  Created by Stephen Cao on 24/6/19.
//  Copyright © 2019 Stephencao Cao. All rights reserved.
//

import UIKit

struct SCChartData {
    var craftingCost: Int = 0
    var dustValue: Int = 0
    
    var manaValues: [Int]?
    var typeCount:[Int]{
        return [hero,minion,spell,weapon]
    }
    var hero: Int = 0
    var minion: Int = 0
    var spell: Int = 0
    var weapon: Int = 0
    
    var rarityCount:[Int]{
        return [common, free, rare, epic, legendary]
    }
    var common: Int = 0
    var free: Int = 0
    var rare: Int = 0
    var epic: Int = 0
    var legendary: Int = 0
    
    var dustCost: Int = 0
    var cardClassName: String?
}
