//
//  AddNewLocationView.swift
//  Clima
//
//  Created by Igor Fernandes on 02/03/23.
//

import UIKit

protocol AnyAddNewLocationView: AnyObject {
    var presenter: AnyAddNewLocationPresenter? { get set }
    
    func updateCitiesSuggestions(predictions: [Prediction])
}

class AddNewLocationView: UIViewController, AnyAddNewLocationView {
    var presenter: AnyAddNewLocationPresenter?
    
    var predictions: [Prediction] = [Prediction]()
    
    lazy var searchBarController: UISearchController = {
        let searchBarItem = UISearchController(searchResultsController: SearchResultsViewController())
        searchBarItem.searchBar.placeholder = "Search for a city..."
        searchBarItem.searchBar.searchBarStyle = .minimal
        return searchBarItem
    }()
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundColor
        title = "Add new location"
        navigationItem.searchController = searchBarController
        
        searchBarController.searchResultsUpdater = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    func updateCitiesSuggestions(predictions: [Prediction]) {
        self.predictions = predictions
        
        DispatchQueue.main.async { [weak self] in
            if let self {
                let resultController = self.searchBarController.searchResultsController as? SearchResultsViewController
                resultController?.predictions = self.predictions
            }
        }
    }
}

extension AddNewLocationView: SearchResultsViewDelegate {
    func didSelectItem(with city: String) {
        presenter?.fetchWeatherData(for: city)
    }
}

extension AddNewLocationView: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let resultController = searchBarController.searchResultsController as? SearchResultsViewController
        resultController?.delegate = self
        
        if let searchBarText = searchBarController.searchBar.text {
            if !searchBarText.hasPrefix(" ") && searchBarText.count > 0 {
                presenter?.searchFor(userInput: searchBarText)
            }
        }
    }
}
