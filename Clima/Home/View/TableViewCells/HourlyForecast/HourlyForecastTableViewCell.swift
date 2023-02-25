//
//  HourlyForecastTableViewCell.swift
//  Clima
//
//  Created by Igor Fernandes on 25/02/23.
//

import UIKit

class HourlyForecastTableViewCell: UITableViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
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
}

extension HourlyForecastTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HourlyForecastCollectionViewCell.identifier, for: indexPath) as? HourlyForecastCollectionViewCell else { return UICollectionViewCell() }
        cell.setupCell(label: "Now", icon: "10d", tempLabel: "26°")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 50, height: 120)
    }
}
