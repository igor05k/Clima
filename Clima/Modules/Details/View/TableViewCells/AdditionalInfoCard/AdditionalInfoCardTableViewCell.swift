//
//  AdditionalInfoCardTableViewCell.swift
//  Clima
//
//  Created by Igor Fernandes on 13/03/23.
//

import UIKit

class AdditionalInfoCardTableViewCell: UITableViewCell {
    @IBOutlet weak var outerContainerView: UIView!
    
    @IBOutlet weak var majorStackView: UIStackView!
    
    @IBOutlet weak var windStackView: UIStackView!
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var windValueLabel: UILabel!
    
    @IBOutlet weak var feelsLikeStackView: UIStackView!
    @IBOutlet weak var feelsLikeLabel: UILabel!
    @IBOutlet weak var feelsLikeValueLabel: UILabel!
    
    @IBOutlet weak var visibilityStackView: UIStackView!
    @IBOutlet weak var visibilityLabel: UILabel!
    @IBOutlet weak var visibilityValueLabel: UILabel!
    
    static let identifier: String = String(describing: AdditionalInfoCardTableViewCell.self)
    
    static func nib() -> UINib {
        return UINib(nibName: identifier, bundle: nil)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        defaultConfigForVisualElements()
        
        layer.cornerRadius = 10
    }
    
    func defaultConfigForVisualElements() {
        windLabel.text = "Wind"
        feelsLikeLabel.text = "Feels Like"
        visibilityLabel.text = "Visibility"
    }
    
    func setupCell(city: HourlyForecastEntity) {
        let windSpeed = city.list?[0].wind?.speed ?? 0
        windValueLabel.text = String(windSpeed).prefix(4) + "m/s"
        
        let feelsLike = city.list?[0].main?.feelsLike ?? 0
        feelsLikeValueLabel.text = String(Int(feelsLike)).prefix(2) + "°C"
        
        let visib = city.list?[0].visibility?.metersToKm() ?? 0
        visibilityValueLabel.text = String(visib) + "km"
    }
}
