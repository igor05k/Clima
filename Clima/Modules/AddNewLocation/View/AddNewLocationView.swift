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
    
    @objc func didTapSearch() {
        print(#function)
    }
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundColor
        title = "Add new location"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.searchController = searchBarController
        
        searchBarController.searchResultsUpdater = self
    }
    
    func updateCitiesSuggestions(predictions: [Prediction]) {
        self.predictions = predictions
    }
}

extension AddNewLocationView: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let resultController = searchBarController.searchResultsController as? SearchResultsViewController
        
        if let searchBarText = searchBarController.searchBar.text {
            if !searchBarText.hasPrefix(" ") && searchBarText.count > 0 {
                presenter?.searchFor(userInput: searchBarText) {
                    resultController?.predictions = self.predictions
                }
            }
        }
    }
}
