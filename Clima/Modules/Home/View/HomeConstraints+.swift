//
//  HomeConstraints+.swift
//  Clima
//
//  Created by Igor Fernandes on 25/02/23.
//

import UIKit

extension HomeView {
    func configAddNewLocationButton() {
        view.addSubview(addNewLocationButton)
        addNewLocationButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            addNewLocationButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            addNewLocationButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5),
            addNewLocationButton.widthAnchor.constraint(equalToConstant: 40),
            addNewLocationButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    func configCityLbl() {
        view.addSubview(cityName)
        
        NSLayoutConstraint.activate([
            cityName.topAnchor.constraint(equalTo: addNewLocationButton.bottomAnchor, constant: 20),
            cityName.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            cityName.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
        ])
    }
    
    func configTempStackView() {
        view.addSubview(tempStackView)
        tempStackView.addArrangedSubview(temperatureIcon)
        tempStackView.addArrangedSubview(temperatureLabel)
        
        NSLayoutConstraint.activate([
            tempStackView.topAnchor.constraint(equalTo: cityName.bottomAnchor, constant: 10),
            tempStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tempStackView.widthAnchor.constraint(equalToConstant: 160),
            tempStackView.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    func configTempDescription() {
        view.addSubview(tempDescription)
        
        NSLayoutConstraint.activate([
            tempDescription.topAnchor.constraint(equalTo: tempStackView.bottomAnchor, constant: 10),
            tempDescription.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            tempDescription.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
        ])
    }
    
    func configMinMaxStackView() {
        view.addSubview(minMaxStackView)
        minMaxStackView.addArrangedSubview(maxTemperature)
        minMaxStackView.addArrangedSubview(minTemperature)
        
        NSLayoutConstraint.activate([
            minMaxStackView.topAnchor.constraint(equalTo: tempDescription.bottomAnchor, constant: 10),
            minMaxStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
        ])
    }
    
    func configTableViewConstraints() {
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: minMaxStackView.bottomAnchor, constant: 10),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
//            tableView.heightAnchor.constraint(equalToConstant: 150)
        ])
    }
}
