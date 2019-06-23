//
//  SCDeckChartView.swift
//  CardsHelper
//
//  Created by Stephen Cao on 23/6/19.
//  Copyright © 2019 Stephencao Cao. All rights reserved.
//

import UIKit
import AAInfographics

class SCDeckChartView: UIView {
    private let aaChartView = AAChartView()
    var chartData: [Int]?{
        didSet{
            guard let chartData = chartData else{
                return 
            }
            aaChartView.aa_onlyRefreshTheChartDataWithChartModelSeries([
                AASeriesElement()
                    .name("Mana")
                    .data(chartData)
                    .toDic()!])
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupChartView()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
private extension SCDeckChartView{
    func setupChartView(){
        aaChartView.frame = CGRect(x:0,y:0,width:bounds.width,height:bounds.height)
        aaChartView.isClearBackgroundColor = true
        addSubview(aaChartView)
        aaChartView.aa_drawChartWithChartModel(setupChartModel())
    }
    func setupChartModel()->AAChartModel{
        let chartModel = AAChartModel()
            .chartType(.column)
            .title("Deck Type")
            .inverted(false)
            .backgroundColor("#E6D7B0")
            .borderRadius(5)
            .yAxisTitle("Mana")
            .legendEnabled(false)
            .categories(["0", "1", "2", "3", "4", "5",
                         "6", "7+"])
            .colorsTheme(["#569DDF"])
            .series([
                AASeriesElement()
                    .name("Mana")
                    .data([0,0,0,0,0,0,0])
                    .toDic()!])
        return chartModel
    }
}
