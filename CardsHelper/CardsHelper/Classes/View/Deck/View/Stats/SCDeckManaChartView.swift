//
//  SCDeckManaChartView.swift
//  CardsHelper
//
//  Created by Stephen Cao on 23/6/19.
//  Copyright © 2019 Stephencao Cao. All rights reserved.
//

import UIKit
import AAInfographics

class SCDeckManaChartView: UIView {
    private let aaChartView = AAChartView()
    var chartData: SCChartData?{
        didSet{
            guard let chartData = chartData,
                  let manaValues = chartData.manaValues else{
                return 
            }
            aaChartView.aa_onlyRefreshTheChartDataWithChartModelSeries([
                AASeriesElement()
                    .name("Mana")
                    .data(manaValues)
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
private extension SCDeckManaChartView{
    func setupChartView(){
        aaChartView.frame = CGRect(x:0,y:0,width:bounds.width,height:bounds.height)
        aaChartView.isClearBackgroundColor = true
        addSubview(aaChartView)
        aaChartView.aa_drawChartWithChartModel(setupChartModel())
    }
    func setupChartModel()->AAChartModel{
        let chartModel = AAChartModel()
            .chartType(.column)
            .title("Mana Cost")
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
                    .data([0,0,0,0,0,0,0,0])
                    .toDic()!])
        return chartModel
    }
}
