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
    
    static let identifier: String = String(describing: RainProbabilityTableViewCell.self)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        barChartView.delegate = self
        
//        setChartConstraints()
        addSubview(barChartView)
        configChart()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        barChartView.frame = bounds
    }
    
    func setChartConstraints() {
        addSubview(barChartView)
        
        NSLayoutConstraint.activate([
            barChartView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            barChartView.leadingAnchor.constraint(equalTo: leadingAnchor),
            barChartView.trailingAnchor.constraint(equalTo: trailingAnchor),
            barChartView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func configChart() {
        // Criando os dados fictícios
        let months = ["Jan", "Fev", "Mar", "Abr", "Mai", "Jun"]
        let sales = [20.0, 4.0, 6.0, 3.0, 12.0, 16.0]

        // Criando um array de objetos BarChartDataEntry com os dados
        var entries = [BarChartDataEntry]()
        for i in 0..<months.count {
            let entry = BarChartDataEntry(x: Double(i), y: sales[i])
            entries.append(entry)
        }

        // Criando um objeto BarChartDataSet com o array de dados
        let dataSet = BarChartDataSet(entries: entries, label: "Vendas")

        // Personalizando as cores das barras
        dataSet.colors = ChartColorTemplates.joyful()

        // Criando um objeto BarChartData com o objeto dataSet
        let data = BarChartData(dataSet: dataSet)
        barChartView.data = data
    }
}
