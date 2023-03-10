//
//  CityTableViewCell.swift
//  Clima
//
//  Created by Igor Fernandes on 10/03/23.
//

import UIKit

class CityTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cityTemp: UILabel!
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var tempIcon: UIImageView!
    
    static let identifier: String = String(describing: CityTableViewCell.self)
    
    static func nib() -> UINib {
        return UINib(nibName: identifier, bundle: nil)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        configLabels()
        
        cityTemp.text = "25°"
        cityName.text = "São Paulo"
        tempIcon.image = UIImage(named: "10d")
    }
    
    private func configLabels() {
        cityTemp.font = .systemFont(ofSize: 42, weight: .bold)
        cityName.font = .systemFont(ofSize: 30, weight: .medium)
    }
    
    func setupCell(data: CityInfo) {
        cityTemp.text = String(data.temp) + "°C"
        cityName.text = data.name
        
        if let url = URL(string: "http://openweathermap.org/img/w/\(data.icon).png") {
            tempIcon.downloadImage(from: url)
        }
    }
}
