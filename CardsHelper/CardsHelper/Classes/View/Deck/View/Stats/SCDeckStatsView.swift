//
//  SCDeckStatsView.swift
//  CardsHelper
//
//  Created by Stephen Cao on 23/6/19.
//  Copyright © 2019 Stephencao Cao. All rights reserved.
//

import UIKit

class SCDeckStatsView: UIView {
    private lazy var chart = SCDeckChartView(frame: chartView.bounds)
    @IBOutlet weak var chartView: UIView!
    
    class func statsView()->SCDeckStatsView{
        let nib = UINib(nibName: "SCDeckStatsView", bundle: nil)
        let v = nib.instantiate(withOwner: self, options: nil)[0] as! SCDeckStatsView
        v.frame = UIScreen.main.bounds
        return v
    }
    override func didMoveToWindow() {
        super.didMoveToWindow()
        layoutIfNeeded()
        chartView.addSubview(chart)
    }
}
extension SCDeckStatsView{
    func expandStatsView(completion: @escaping ()->()){
        addPopVerticalAnimation(fromValue: -UIScreen.screenHeight() / 2, toValue: UIScreen.screenHeight() / 2, springBounciness: 6, springSpeed: 12, delay: 0) { (_, _) in
            completion()
        }
        chart.chartData = [1,1,2,8,7,2,1,2]
    }
    func shrinkStatsView(completion:@escaping ()->()){
        addPopVerticalAnimation(fromValue: UIScreen.screenHeight() / 2, toValue: -UIScreen.screenHeight() / 2, springBounciness: 6, springSpeed: 12, delay: 0) { (_, _) in
            completion()
        }
    }
}
