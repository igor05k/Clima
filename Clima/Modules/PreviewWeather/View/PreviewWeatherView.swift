//
//  PreviewWeatherView.swift
//  Clima
//
//  Created by Igor Fernandes on 09/03/23.
//

import UIKit

protocol AnyPreviewWeatherView: AnyObject {
    var presenter: AnyPreviewWeatherPresenter? { get set }
}

class PreviewWeatherViewController: UIViewController, AnyPreviewWeatherView {
    
    var presenter: AnyPreviewWeatherPresenter?
    
    var data: HourlyForecastEntity?
    
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
    
    func checkForMaxAndMin(_ minMaxAndIcon: [String : (tempMin: Double, tempMax: Double, icon: String)], _ calendar: Calendar) {
        if let temp = minMaxAndIcon[WeatherUtils.shared.currentDate] {
            let min = Int(floor(temp.tempMin.kelvinToCelsius()))
            let max = Int(floor(temp.tempMax.kelvinToCelsius()))
            
            minTemperature.text = String(min).prefix(2) + "°C"
            maxTemperature.text = String(max).prefix(2) + "°C"
        } else {
            guard let tomorrow = calendar.date(byAdding: .hour, value: 6, to: Date()) else { return }
            
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            
            let currentDateString = formatter.string(from: tomorrow)
            let tempMin = Int(floor(minMaxAndIcon[currentDateString]?.tempMin.kelvinToCelsius() ?? 0))
            let tempMax = Int(floor(minMaxAndIcon[currentDateString]?.tempMax.kelvinToCelsius() ?? 0))
            minTemperature.text = String(tempMin).prefix(2) + "°C"
            maxTemperature.text = String(tempMax).prefix(2) + "°C"
        }
    }
    
    func configWeather(data: HourlyForecastEntity) {
        self.data = data
        
        let calendar = Calendar.current
        let minMaxAndIcon = WeatherUtils.shared.checkUniqueForecastDays(model: data)
        
        checkForMaxAndMin(minMaxAndIcon, calendar)
        
        let cityName = data.city?.name ?? "No name"
        let descriptionTemp = data.list?[0].weather?[0].tempDescription ?? "No desc"
        let icon = data.list?[0].weather?[0].icon ?? ""
        let currentTemp = Int(floor(data.list?[0].main?.temp?.kelvinToCelsius() ?? 0))
        
        cityLabel.text = cityName
        tempLabel.text = String(currentTemp).prefix(2) + "°C"
        tempDescriptionLabel.text = descriptionTemp.capitalized
        
        if let url = URL(string: "http://openweathermap.org/img/w/\(icon).png") {
            temperatureIcon.downloadImage(from: url)
        }
    }
    
    @objc func saveCity() {
        let cityName = data?.city?.name ?? "No name"
        let currentTemp = Int(floor(data?.list?[0].main?.temp?.kelvinToCelsius() ?? 0))
        let icon = data?.list?[0].weather?[0].icon ?? ""
        let lat = data?.city?.coord?.lat ?? 0
        let long = data?.city?.coord?.lon ?? 0
        
        let city = CityInfo(name: cityName, temp: currentTemp, icon: icon, lat: lat, lon: long)
        presenter?.didTapSaveCity(data: city)
    }
}
