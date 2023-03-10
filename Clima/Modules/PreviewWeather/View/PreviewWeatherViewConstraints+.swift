//
//  PreviewWeatherViewConstraints+.swift
//  Clima
//
//  Created by Igor Fernandes on 10/03/23.
//

import UIKit

extension PreviewWeatherViewController {
    func setTempLabelConstraints() {
        view.addSubview(tempLabel)
        
        NSLayoutConstraint.activate([
            tempLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            tempLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            tempLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
    }
    
    func setCityLabelConstraints() {
        view.addSubview(cityLabel)
        
        NSLayoutConstraint.activate([
            cityLabel.topAnchor.constraint(equalTo: tempLabel.bottomAnchor, constant: 15),
            cityLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            cityLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
    }
    
    func configMinMaxStackView() {
        view.addSubview(minMaxStackView)
        minMaxStackView.addArrangedSubview(maxTemperature)
        minMaxStackView.addArrangedSubview(minTemperature)
        
        NSLayoutConstraint.activate([
            minMaxStackView.topAnchor.constraint(equalTo: cityLabel.bottomAnchor, constant: 15),
            minMaxStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
        ])
    }
    
    func setTempDescriptionConstraints() {
        view.addSubview(tempDescriptionLabel)
        
        NSLayoutConstraint.activate([
            tempDescriptionLabel.topAnchor.constraint(equalTo: cityLabel.bottomAnchor, constant: 10),
            tempDescriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            tempDescriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
    }
    
    func setTempIcon() {
        view.addSubview(temperatureIcon)
        
        NSLayoutConstraint.activate([
            temperatureIcon.topAnchor.constraint(equalTo: tempDescriptionLabel.bottomAnchor, constant: 10),
            temperatureIcon.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            temperatureIcon.widthAnchor.constraint(equalToConstant: 70),
            temperatureIcon.heightAnchor.constraint(equalToConstant: 70)
        ])
    }
}
