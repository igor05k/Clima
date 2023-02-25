//
//  HourlyForecastTableViewCell.swift
//  Clima
//
//  Created by Igor Fernandes on 25/02/23.
//

import UIKit

class HourlyForecastTableViewCell: UITableViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var hourlyForecastInfo: HourlyForecastEntity?
    
    static let identifier: String = String(describing: HourlyForecastTableViewCell.self)
    
    static func nib() -> UINib {
        return UINib(nibName: identifier, bundle: nil)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        configCollectionView()
        selectionStyle = .none
        collectionView.backgroundColor = .backgroundColor
    }
    
    private func configCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(HourlyForecastCollectionViewCell.nib(), forCellWithReuseIdentifier: HourlyForecastCollectionViewCell.identifier)
    }
    
    func configureElements(model: HourlyForecastEntity) {
        DispatchQueue.main.async { [weak self] in
            self?.hourlyForecastInfo = model
            self?.collectionView.reloadData()
        }
    }
    
    func convertToAmPm(_ hour: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        if let date = dateFormatter.date(from: hour) {
            dateFormatter.dateFormat = "h a"
            let hourString = dateFormatter.string(from: date)
            return hourString
        }
        
        return nil
    }
    
    func kelvinToCelsius(_ k: Double) -> Double { k - 273.15 }
}

extension HourlyForecastTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HourlyForecastCollectionViewCell.identifier, for: indexPath) as? HourlyForecastCollectionViewCell else { return UICollectionViewCell() }
        
        let hour = hourlyForecastInfo?.list?[indexPath.row].dtTxt ?? "No time"
        let icon = hourlyForecastInfo?.list?[indexPath.row].weather?[0].icon ?? ""
        let temp = kelvinToCelsius(hourlyForecastInfo?.list?[indexPath.row].main?.temp ?? 0)
        
        let formattedTemp = String(temp).prefix(1) + "°"
        
        if let convertedHour = convertToAmPm(hour) {
            cell.setupCell(label: convertedHour, icon: icon, tempLabel: String(formattedTemp))
        }

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return hourlyForecastInfo?.list?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 65, height: 120)
    }
}
