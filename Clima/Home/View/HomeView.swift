//
//  HomeView.swift
//  Clima
//
//  Created by Igor Fernandes on 23/02/23.
//

import UIKit

protocol AnyHomeView: AnyObject {
    var presenter: AnyHomePresenter? { get set }
    
    func updateCurrentTemperature(with weatherInfo: CurrentWeatherEntity)
    func updateHourlyForecast(with weatherInfo: HourlyForecastEntity)
}

class HomeView: UIViewController, AnyHomeView {
    var presenter: AnyHomePresenter?
    
    private var weatherInfo: CurrentWeatherEntity?
    private var hourlyForecastInfo: HourlyForecastEntity?
    
//    private var testWeatherObjectInfo: CurrentWeatherEntity?
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundColor

        configCityLbl()
        configTempStackView()
        configTempDescription()
        configMinMaxStackView()
        configTableView()
        configTableViewConstraints()
    }
    
    lazy var tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    lazy var cityName: UILabel = {
        let city = UILabel()
        city.text = "São Paulo"
        city.textAlignment = .center
        city.numberOfLines = 1
        city.font = .systemFont(ofSize: 20, weight: .bold)
        city.translatesAutoresizingMaskIntoConstraints = false
        return city
    }()
    
    lazy var tempStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .fillProportionally
        stack.spacing = 10
        return stack
    }()
    
    lazy var temperatureLabel: UILabel = {
        let temp = UILabel()
        temp.text = "26°"
        temp.textAlignment = .center
        temp.numberOfLines = 1
        temp.font = .systemFont(ofSize: 46, weight: .medium)
        temp.translatesAutoresizingMaskIntoConstraints = false
        return temp
    }()
    
    lazy var temperatureIcon: UIImageView = {
        let tempIcon = UIImageView()
        tempIcon.image = UIImage(named: "10d")
        tempIcon.contentMode = .scaleAspectFill
        tempIcon.translatesAutoresizingMaskIntoConstraints = false
        return tempIcon
    }()
    
    lazy var tempDescription: UILabel = {
        let desc = UILabel()
        desc.text = "Scattered rain"
        desc.textAlignment = .center
        desc.numberOfLines = 1
        desc.font = .systemFont(ofSize: 20, weight: .medium)
        desc.translatesAutoresizingMaskIntoConstraints = false
        return desc
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
    
    private func configTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(HourlyForecastTableViewCell.nib(), forCellReuseIdentifier: HourlyForecastTableViewCell.identifier)
    }
    
    func updateCurrentTemperature(with weatherInfo: CurrentWeatherEntity) {
        DispatchQueue.main.async { [weak self] in
            self?.weatherInfo = weatherInfo
            
            let temp = self?.kelvinToCelsius(weatherInfo.main?.temp ?? 0)
            
            let desc = weatherInfo.weather?[0].description?.capitalized
            let icon = weatherInfo.weather?[0].icon
            
            if let url = URL(string: "http://openweathermap.org/img/w/\(icon ?? "").png") {
                self?.temperatureIcon.downloadImage(from: url)
            }
            
            self?.tempDescription.text = desc ?? "No description"
            self?.cityName.text = weatherInfo.name ?? "No city found"
            self?.temperatureLabel.text = String(temp ?? 0).prefix(1) + "°"
        }
    }
    
    func updateHourlyForecast(with weatherInfo: HourlyForecastEntity) {
        DispatchQueue.main.async { [weak self] in
            self?.hourlyForecastInfo = weatherInfo
            self?.tableView.reloadData()
        }
    }
    
    func kelvinToCelsius(_ k: Double) -> Double { k - 273.15 }
}

extension HomeView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HourlyForecastTableViewCell.identifier, for: indexPath) as? HourlyForecastTableViewCell else { return UITableViewCell()}
        
        if let hourlyForecastInfo {
            cell.configureElements(model: hourlyForecastInfo)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { 150 }
}
