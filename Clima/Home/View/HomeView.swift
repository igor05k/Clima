//
//  HomeView.swift
//  Clima
//
//  Created by Igor Fernandes on 23/02/23.
//

import UIKit

protocol AnyHomeView: AnyObject {
    var presenter: AnyHomePresenter? { get set }
    
    func updateView(with users: HomeEntity)
}

// icons: http://openweathermap.org/img/w/10d.png

class HomeView: UIViewController, AnyHomeView {
    var presenter: AnyHomePresenter?
    
    private var users: [HomeEntity] = []
    
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
        city.font = .systemFont(ofSize: 22, weight: .bold)
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
        desc.font = .systemFont(ofSize: 22, weight: .medium)
        desc.translatesAutoresizingMaskIntoConstraints = false
        return desc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        configCityLbl()
        configTempStackView()
        configTempDescription()
        //        configTableView()
    }
    
    private func configTableView() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    private func configCityLbl() {
        view.addSubview(cityName)
        
        NSLayoutConstraint.activate([
            cityName.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            cityName.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            cityName.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
        ])
    }
    
    private func configTempStackView() {
        view.addSubview(tempStackView)
        tempStackView.addArrangedSubview(temperatureIcon)
        tempStackView.addArrangedSubview(temperatureLabel)
        
        NSLayoutConstraint.activate([
            tempStackView.topAnchor.constraint(equalTo: cityName.bottomAnchor, constant: 10),
            tempStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tempStackView.widthAnchor.constraint(equalToConstant: 150),
            tempStackView.heightAnchor.constraint(equalToConstant: 120)
        ])
    }
    
    private func configTempDescription() {
        view.addSubview(tempDescription)
        
        NSLayoutConstraint.activate([
            tempDescription.topAnchor.constraint(equalTo: tempStackView.bottomAnchor, constant: 10),
            tempDescription.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            tempDescription.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
        ])
    }
    
    func updateView(with users: HomeEntity) {
        DispatchQueue.main.async { [weak self] in
            self?.users = [users]
            let temp = self?.kelvinToCelsius(users.main?.temp ?? 0)
            
            let desc = users.weather?[0].description?.capitalized
            let icon = users.weather?[0].icon
            
            if let url = URL(string: "http://openweathermap.org/img/w/\(icon ?? "").png") {
                self?.temperatureIcon.downloadImage(from: url)
            }
            
            self?.tempDescription.text = desc ?? "No description"
            self?.cityName.text = users.name ?? "No city found"
            self?.temperatureLabel.text = String(temp ?? 0).prefix(1) + "°"
            
            // TODO
            // self?.tableView.reloadData()
        }
    }
    
    func kelvinToCelsius(_ k: Double) -> Double { k - 273.15 }
}

extension HomeView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let temp = kelvinToCelsius(users[indexPath.row].main?.temp ?? 0)
        cell.textLabel?.text = String(temp)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
}

extension UIImageView {
    func downloadImage(from url: URL) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200, let data = data else {
                print("Error downloading image: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            DispatchQueue.main.async {
                self.image = UIImage(data: data)
            }
        }.resume()
    }
}
