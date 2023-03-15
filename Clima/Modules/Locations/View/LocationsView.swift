//
//  LocationsView.swift
//  Clima
//
//  Created by Igor Fernandes on 07/03/23.
//

import UIKit

protocol AnyLocationsView: AnyObject {
    var presenter: LocationsPresenter? { get set }
    
    func updateCities(with data: [CityInfo])
    func updateTableView(index: Int)
}

class LocationsView: UIViewController, AnyLocationsView {
    
    var presenter: LocationsPresenter?
    
    private let refreshControl = UIRefreshControl()
    private var cities: [CityInfo] = [CityInfo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundColor
        title = "Locations"
        
        configRefreshControl()
        configTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
        presenter?.fetchData()
    }
    
    lazy var tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    private func configTableView() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .backgroundColor
        tableView.refreshControl = refreshControl

        // register cell
        tableView.register(CityTableViewCell.nib(), forCellReuseIdentifier: CityTableViewCell.identifier)
    }
    
    func updateCities(with data: [CityInfo]) {
        self.cities = data
        
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    func updateTableView(index: Int) {
        cities.remove(at: index)
        tableView.reloadData()
    }
    
    private func configRefreshControl() {
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        refreshControl.tintColor = .white
    }
    
    @objc private func refreshData(_ sender: Any) {
        presenter?.updateData(cities: cities)
        refreshControl.endRefreshing()
    }

}

extension LocationsView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CityTableViewCell.identifier, for: indexPath) as? CityTableViewCell else { return UITableViewCell() }
        cell.setupCell(data: cities[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { 130 }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cityChosen = cities[indexPath.row]
        presenter?.didTapCityDetails(city: cityChosen)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            presenter?.delete(item: cities[indexPath.row], id: indexPath.row)
        }
    }
}
