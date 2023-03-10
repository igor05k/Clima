//
//  PreviewWeatherView.swift
//  Clima
//
//  Created by Igor Fernandes on 09/03/23.
//

import UIKit

class PreviewWeatherViewController: UIViewController {
    
    lazy var tempLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "26°C"
        lbl.font = .systemFont(ofSize: 42, weight: .bold)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    lazy var cityLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Guarulhos"
        lbl.font = .systemFont(ofSize: 26, weight: .regular)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    lazy var minMaxStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .fillEqually
        stack.spacing = 10
        return stack
    }()
    
    lazy var minTemperature: UILabel = {
        let minTemp = UILabel()
        minTemp.text = "20°"
        minTemp.translatesAutoresizingMaskIntoConstraints = false
        return minTemp
    }()
    
    lazy var maxTemperature: UILabel = {
        let maxTemp = UILabel()
        maxTemp.text = "29°"
        maxTemp.translatesAutoresizingMaskIntoConstraints = false
        return maxTemp
    }()
    
    lazy var tempDescriptionLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Scattered rain"
        lbl.font = .systemFont(ofSize: 26, weight: .regular)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    lazy var temperatureIcon: UIImageView = {
        let tempIcon = UIImageView()
        tempIcon.image = UIImage(named: "10d")
        tempIcon.contentMode = .scaleAspectFill
        tempIcon.translatesAutoresizingMaskIntoConstraints = false
        return tempIcon
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundColor
        
        let addButton = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveCity))
        navigationItem.rightBarButtonItem = addButton
        
        setTempLabelConstraints()
        setCityLabelConstraints()
        configMinMaxStackView()
        setTempDescriptionConstraints()
        setTempIcon()
    }
    
    func configWeather(data: CurrentWeatherEntity) {
        let tempMin = data.main?.tempMin ?? 0
        let tempMax = data.main?.tempMax ?? 0
        let temp = data.main?.temp ?? 0
        let cityName = data.name ?? "No data"
        let descriptionTemp = data.weather?[0].description ?? "No description"
        let icon = data.weather?[0].icon ?? ""
        
        cityLabel.text = cityName
        minTemperature.text = String(tempMin - 273.15).prefix(2) + "°C"
        maxTemperature.text = String(tempMax - 273.15).prefix(2) + "°C"
        tempLabel.text = String(temp - 273.15).prefix(2) + "°C"
        tempDescriptionLabel.text = descriptionTemp.capitalized
        
        if let url = URL(string: "http://openweathermap.org/img/w/\(icon).png") {
            temperatureIcon.downloadImage(from: url)
        }
    }
    
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
    
    @objc func saveCity() {
        print(#function)
    }
}
