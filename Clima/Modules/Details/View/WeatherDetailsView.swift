//
//  WeatherDetailsView.swift
//  Clima
//
//  Created by Igor Fernandes on 13/03/23.
//

import UIKit

protocol AnyWeatherDetailsView: AnyObject {
    var presenter: AnyWeatherDetailsPresenter? { get set }
    
    func updateView(with cityInfo: HourlyForecastEntity)
}

enum Sections: Int {
    case title = 0
    case hourlyForecast = 1
    case infoCard = 2
    case rainProbability = 3
    case airPollution = 4
}

class WeatherDetailsView: UIViewController, AnyWeatherDetailsView {
    var presenter: AnyWeatherDetailsPresenter?
    
    private var hourlyForecastInfo: HourlyForecastEntity?
   
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .backgroundColor
        configTableView()
        configTableViewConstraints()
    }
    
    lazy var cityLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Guarulhos"
        lbl.font = .systemFont(ofSize: 26, weight: .regular)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    lazy var tempLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "26°C"
        lbl.font = .systemFont(ofSize: 42, weight: .bold)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    lazy var tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    func setTempLabelConstraints() {
        view.addSubview(tempLabel)
        
        NSLayoutConstraint.activate([
            tempLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tempLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            tempLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
    }
    
    private func configTableView() {
        view.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .backgroundColor
        
        // generic cell for text
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        tableView.register(HourlyForecastTableViewCell.nib(), forCellReuseIdentifier: HourlyForecastTableViewCell.identifier)
        tableView.register(AdditionalInfoCardTableViewCell.nib(), forCellReuseIdentifier: AdditionalInfoCardTableViewCell.identifier)
        tableView.register(RainProbabilityTableViewCell.self, forCellReuseIdentifier: RainProbabilityTableViewCell.identifier)
    }
    
    func configTableViewConstraints() {
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func updateView(with cityInfo: HourlyForecastEntity) {
        DispatchQueue.main.async { [weak self] in
            self?.hourlyForecastInfo = cityInfo
            self?.tableView.reloadData()
        }
    }
}

extension WeatherDetailsView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case Sections.title.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            
            cell.selectionStyle = .none
            var config = cell.defaultContentConfiguration()
            
            if let hourlyForecastInfo {
                config.text = String(Int(hourlyForecastInfo.list?[0].main?.temp?.kelvinToCelsius() ?? 0)).prefix(2) + "°C"
            }
            
            config.textProperties.font = .systemFont(ofSize: 46, weight: .semibold)
            cell.contentConfiguration = config
            
            return cell
        case Sections.hourlyForecast.rawValue:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: HourlyForecastTableViewCell.identifier, for: indexPath) as? HourlyForecastTableViewCell else { return UITableViewCell() }
            
            if let hourlyForecastInfo {
                cell.configureElements(model: hourlyForecastInfo)
            }
            
            return cell
        case Sections.infoCard.rawValue:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: AdditionalInfoCardTableViewCell.identifier, for: indexPath) as? AdditionalInfoCardTableViewCell else { return UITableViewCell() }
            
            if let hourlyForecastInfo {
                cell.setupCell(city: hourlyForecastInfo)
            }
            
            return cell
        case Sections.rainProbability.rawValue:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: RainProbabilityTableViewCell.identifier, for: indexPath) as? RainProbabilityTableViewCell else { return UITableViewCell() }
            
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case Sections.title.rawValue:
            return 70
        case Sections.hourlyForecast.rawValue:
            return 150
        case Sections.infoCard.rawValue:
            return 100
        case Sections.rainProbability.rawValue:
            return 300
        default:
            return 100
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case Sections.rainProbability.rawValue:
            return "Rain Probability"
        case Sections.airPollution.rawValue:
            return "Air Pollution"
        default:
            return nil
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
}
