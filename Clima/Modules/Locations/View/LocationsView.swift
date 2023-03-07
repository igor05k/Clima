//
//  LocationsView.swift
//  Clima
//
//  Created by Igor Fernandes on 07/03/23.
//

import UIKit

protocol AnyLocationsView: AnyObject {
    var presenter: LocationsPresenter? { get set }
}

class LocationsView: UIViewController, AnyLocationsView {
    var presenter: LocationsPresenter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray5
    }
}
