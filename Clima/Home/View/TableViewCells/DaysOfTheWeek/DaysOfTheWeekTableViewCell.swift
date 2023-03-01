//
//  DaysOfTheWeekTableViewCell.swift
//  Clima
//
//  Created by Igor Fernandes on 25/02/23.
//

import UIKit

class DaysOfTheWeekTableViewCell: UITableViewCell {
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var dayOfTheWeekLbl: UILabel!
    @IBOutlet weak var weatherIconImageView: UIImageView!
    @IBOutlet weak var minMaxTempStackView: UIStackView!
    @IBOutlet weak var maxTempLbl: UILabel!
    @IBOutlet weak var minTempLbl: UILabel!
    
    
    static let identifier: String = String(describing: DaysOfTheWeekTableViewCell.self)
    
    static func nib() -> UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        configVisualElements()
        selectionStyle = .none
        backgroundColor = .backgroundColor
        dayOfTheWeekLbl.text = "Sunday"
        weatherIconImageView.image = UIImage(named: "10d")
        maxTempLbl.text = "26°"
        minTempLbl.text = "20°"
    }
    
    func configVisualElements() {
        dayOfTheWeekLbl.font = .systemFont(ofSize: 20, weight: .bold)
        maxTempLbl.font = .systemFont(ofSize: 20, weight: .bold)
        minTempLbl.font = .systemFont(ofSize: 20, weight: .bold)
    }
    
    /// convert date string to weekday
    private func dayOfWeek(from dateString: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        guard let date = dateFormatter.date(from: dateString) else {
            return nil
        }
        
        let dayOfWeekFormatter = DateFormatter()
        dayOfWeekFormatter.dateFormat = "EEEE"
        
        return dayOfWeekFormatter.string(from: date)
    }
    
    func configureElements(model: List) {
        DispatchQueue.main.async { [weak self] in
            let formattedDate = self?.dayOfWeek(from: model.dtTxt ?? "No date")
            self?.dayOfTheWeekLbl.text = formattedDate?.capitalized
        }
    }
}
