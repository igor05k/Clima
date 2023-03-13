//
//  RainProbabilityTableViewCell.swift
//  Clima
//
//  Created by Igor Fernandes on 13/03/23.
//

import UIKit
import Charts

class RainProbabilityTableViewCell: UITableViewCell, ChartViewDelegate {
    
    let barChartView = BarChartView()
    
    let colors: [UIColor] = [
        UIColor(red: 0.506, green: 0.212, blue: 0.729, alpha: 1.0), // #8136BA
        UIColor(red: 0.329, green: 0.141, blue: 0.478, alpha: 1.0), // #55237A
        UIColor(red: 0.678, green: 0.282, blue: 0.980, alpha: 1.0), // #AD48FA
        UIColor(red: 0.161, green: 0.067, blue: 0.231, alpha: 1.0), // #29113B
        UIColor(red: 0.608, green: 0.255, blue: 0.878, alpha: 1.0)  // #9B41E0
    ]
    
    static let identifier: String = String(describing: RainProbabilityTableViewCell.self)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        barChartView.delegate = self
        
        addSubview(barChartView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        barChartView.frame = bounds
    }
    
    /// converts "yyyy-MM-dd HH:mm:ss" to "HH:mm"
    private func formattedHour(_ hour: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        if let date = dateFormatter.date(from: hour) {
            dateFormatter.dateFormat = "HH:mm"
            let time = dateFormatter.string(from: date)
            return time
        }
        
        return nil
    }
    
    func setupCell(with data: HourlyForecastEntity) {
        // pegar os valores de pop e hour
        if let list = data.list {
            let xAxis = barChartView.xAxis

            var entries = [BarChartDataEntry]()
            var hours = [String]()
            
            for (index, value) in list.enumerated() {
                let pop = value.pop ?? 0
                let hour = value.dtTxt ?? ""
                
                if let formattedHour = formattedHour(hour) {
                    hours.append(formattedHour)
                }
                
                entries.append(BarChartDataEntry(x: Double(index), y: pop))
            }
            
            xAxis.valueFormatter = IndexAxisValueFormatter(values: hours)
            xAxis.granularity = 1
            xAxis.labelCount = entries.count
            xAxis.labelPosition = .bottom
            
            let dataSet = BarChartDataSet(entries: entries, label: "Pop")
            dataSet.valueFont = UIFont.systemFont(ofSize: 14)
            dataSet.colors = colors
            
            let data = BarChartData(dataSet: dataSet)
            barChartView.data = data
        }
    }
}
