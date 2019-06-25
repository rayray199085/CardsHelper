//
//  SCDeckStatsView.swift
//  CardsHelper
//
//  Created by Stephen Cao on 23/6/19.
//  Copyright © 2019 Stephencao Cao. All rights reserved.
//

import UIKit

class SCDeckStatsView: UIView {
    private lazy var manaChart = SCDeckManaChartView(frame: manaChartView.bounds)
    private lazy var typeChart = SCDeckTypeChartView(frame: typeChartView.bounds)
    private lazy var rarityChart = SCDeckRarityChartView(frame: rarityChartView.bounds)
    var chartData: SCChartData?{
        didSet{
            manaChart.chartData = chartData
            typeChart.chartData = chartData
            rarityChart.chartData = chartData
            classLabel.text = "\(chartData?.cardClassName ?? "")"
            dustCostLabel.text = "Dust cost: \(String.getLargeNumberWithCommas(num: chartData?.dustCost))"
            classIconImageView.image = UIImage(named: chartData?.cardClassName ?? "classes")
        }
    }
    
    @IBOutlet weak var classIconImageView: UIImageView!
    @IBOutlet weak var dustCostLabel: UILabel!
    @IBOutlet weak var classLabel: UILabel!
    
    @IBOutlet weak var rarityChartView: UIView!
    @IBOutlet weak var manaChartView: UIView!
    @IBOutlet weak var typeChartView: UIView!
    
    class func statsView()->SCDeckStatsView{
        let nib = UINib(nibName: "SCDeckStatsView", bundle: nil)
        let v = nib.instantiate(withOwner: self, options: nil)[0] as! SCDeckStatsView
        v.frame = UIScreen.main.bounds
        return v
    }
    override func didMoveToWindow() {
        super.didMoveToWindow()
        layoutIfNeeded()
        manaChartView.addSubview(manaChart)
        typeChartView.addSubview(typeChart)
        rarityChartView.addSubview(rarityChart)
    }
}
extension SCDeckStatsView{
    func expandStatsView(completion: @escaping ()->()){
        addPopVerticalAnimation(fromValue: -UIScreen.screenHeight() / 2, toValue: UIScreen.screenHeight() / 2, springBounciness: 6, springSpeed: 12, delay: 0) { (_, _) in
            completion()
        }
    }
    func shrinkStatsView(completion:@escaping ()->()){
        addPopVerticalAnimation(fromValue: UIScreen.screenHeight() / 2, toValue: -UIScreen.screenHeight() / 2, springBounciness: 6, springSpeed: 12, delay: 0) { (_, _) in
            completion()
        }
    }
}
