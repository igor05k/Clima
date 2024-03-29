//
//  HourlyForecastCollectionViewCell.swift
//  Clima
//
//  Created by Igor Fernandes on 25/02/23.
//

import UIKit

class HourlyForecastCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var weatherIconImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    
    static let identifier: String = String(describing: HourlyForecastCollectionViewCell.self)
    
    static func nib() -> UINib {
        return UINib(nibName: identifier, bundle: nil)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setupCell(label: String, icon: String, tempLabel: String) {
        timeLabel.text = label
        timeLabel.textColor = .labelColor
        weatherIconImageView.loadImageUsingCache(withUrl: "http://openweathermap.org/img/w/\(icon).png")
        
        temperatureLabel.text = tempLabel
        temperatureLabel.textColor = .labelColor
    }
}
