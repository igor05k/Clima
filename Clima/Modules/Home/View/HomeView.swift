//
//  HomeView.swift
//  Clima
//
//  Created by Igor Fernandes on 23/02/23.
//

import UIKit

typealias NewLocationHandler = (() -> Void)

protocol AnyHomeView: AnyObject {
    var presenter: AnyHomePresenter? { get set }
    
    func updateCurrentTemperature(with weatherInfo: CurrentWeatherEntity)
    func updateHourlyForecast(with weatherInfo: HourlyForecastEntity)
    func updateDailyForecast(with weatherInfo: [String: (tempMin: Double, tempMax: Double, icon: String)]?, keys: [String], weekDays: [String: String])
}

class HomeView: UIViewController, AnyHomeView {
    var presenter: AnyHomePresenter?
    
    var didTapAddNewLocation: NewLocationHandler?
    
    private var dictOfForecasts: [String: (tempMin: Double, tempMax: Double, icon: String)]?
    private var weekDays: [String: String] = [:]
    
    private var keys: [String] = [String]()
    
    private var weatherInfo: CurrentWeatherEntity?
    private var hourlyForecastInfo: HourlyForecastEntity?
    
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
        configBarButtonItem()
    }
    
    @objc func addButtonTapped() {
        presenter?.didTapAddNewLocation()
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
    
    private func configBarButtonItem() {
        let addButton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem = addButton
    }
    
    private func configTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(HourlyForecastTableViewCell.nib(), forCellReuseIdentifier: HourlyForecastTableViewCell.identifier)
        tableView.register(DaysOfTheWeekTableViewCell.nib(), forCellReuseIdentifier: DaysOfTheWeekTableViewCell.identifier)
    }
    
    func updateCurrentTemperature(with weatherInfo: CurrentWeatherEntity) {
        DispatchQueue.main.async { [weak self] in
            self?.weatherInfo = weatherInfo
            
            let temp = self?.presenter?.kelvinToCelsius(weatherInfo.main?.temp ?? 0)
            
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
    
    func updateDailyForecast(with weatherInfo: [String: (tempMin: Double, tempMax: Double, icon: String)]?,
                              keys: [String],
                              weekDays: [String: String]) {
        DispatchQueue.main.async { [weak self] in
            self?.keys = keys
            self?.weekDays = weekDays
            self?.dictOfForecasts = weatherInfo
            self?.tableView.reloadData()
        }
    }
}

extension HomeView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: HourlyForecastTableViewCell.identifier, for: indexPath) as? HourlyForecastTableViewCell else { return UITableViewCell() }
            
            if let hourlyForecastInfo {
                cell.configureElements(model: hourlyForecastInfo)
            }
            
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: DaysOfTheWeekTableViewCell.identifier, for: indexPath) as? DaysOfTheWeekTableViewCell else { return UITableViewCell() }
            
            if let tempMin = dictOfForecasts?[keys[indexPath.row]]?.tempMin,
               let tempMax = dictOfForecasts?[keys[indexPath.row]]?.tempMax,
               let icon = dictOfForecasts?[keys[indexPath.row]]?.icon,
               let weekDays = weekDays[keys[indexPath.row]] {
                
                let tempMinConv = Int(floor(presenter?.kelvinToCelsius(tempMin) ?? 0))
                let tempMaxConv = Int(ceil(presenter?.kelvinToCelsius(tempMax) ?? 0))
                
                cell.configureElements(weekDay: weekDays, tempMin: tempMinConv, tempMax: tempMaxConv, icon: icon)
            }
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return dictOfForecasts?.count ?? 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 150
        } else {
            return 80
        }
    }
}
