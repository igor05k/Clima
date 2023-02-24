//
//  HomeView.swift
//  Clima
//
//  Created by Igor Fernandes on 23/02/23.
//

import UIKit

protocol AnyHomeView: AnyObject {
    var presenter: AnyHomePresenter? { get set }
}

class HomeView: UIViewController, AnyHomeView {
    var presenter: AnyHomePresenter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray
    }
}
