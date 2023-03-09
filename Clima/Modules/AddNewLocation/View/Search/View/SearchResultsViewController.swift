//
//  SearchResultsViewController.swift
//  Clima
//
//  Created by Igor Fernandes on 08/03/23.
//

import UIKit

protocol SearchResultsViewDelegate: AnyObject {
    func didSelectItem(with city: String)
}

class SearchResultsViewController: UIViewController {
    
    weak var delegate: SearchResultsViewDelegate?
    
    var predictions: [Prediction] = [Prediction]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configTableView()
    }
    
    func configTableView() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.backgroundColor = .backgroundColor
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
}

extension SearchResultsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.selectionStyle = .none
        var config = cell.defaultContentConfiguration()
        config.text = predictions[indexPath.row].description ?? ""
        cell.contentConfiguration = config
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return predictions.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.didSelectItem(with: predictions[indexPath.row].description ?? "")
    }
}
