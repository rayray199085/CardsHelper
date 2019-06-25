//
//  SCDeckTypeChartView.swift
//  CardsHelper
//
//  Created by Stephen Cao on 24/6/19.
//  Copyright © 2019 Stephencao Cao. All rights reserved.
//

import UIKit
import AAInfographics

class SCDeckTypeChartView: UIView {

    private let aaChartView = AAChartView()
    var chartData: SCChartData?{
        didSet{
            guard let chartData = chartData else{
                    return
            }
            aaChartView.aa_onlyRefreshTheChartDataWithChartModelSeries([
                AASeriesElement()
                    .name("Type")
                    .data(chartData.typeCount)
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
private extension SCDeckTypeChartView{
    func setupChartView(){
        aaChartView.frame = CGRect(x:0,y:0,width:bounds.width,height:bounds.height)
        aaChartView.isClearBackgroundColor = true
        addSubview(aaChartView)
        aaChartView.aa_drawChartWithChartModel(setupChartModel())
    }
    func setupChartModel()->AAChartModel{
        let chartModel = AAChartModel()
            .chartType(.bar)
            .title("Card Type")
            .inverted(false)
            .backgroundColor("#E6D7B0")
            .borderRadius(5)
            .legendEnabled(false)
            .categories(["Hero", "Minion", "Spell", "Weapon"])
            .colorsTheme(["#fe117c"])
            .series([
                AASeriesElement()
                    .name("Count")
                    .data([0,0,0,0])
                    .toDic()!])
        return chartModel
    }
}
