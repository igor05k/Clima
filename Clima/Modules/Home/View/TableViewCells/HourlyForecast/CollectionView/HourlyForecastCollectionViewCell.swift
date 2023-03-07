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
        
        if let url = URL(string: "http://openweathermap.org/img/w/\(icon).png") {
            weatherIconImageView.downloadImage(from: url)
        }
        
        temperatureLabel.text = tempLabel
    }
}
