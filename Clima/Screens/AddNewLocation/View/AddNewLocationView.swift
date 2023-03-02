//
//  AddNewLocationView.swift
//  Clima
//
//  Created by Igor Fernandes on 02/03/23.
//

import UIKit

protocol AnyAddNewLocationView: AnyObject {
    var presenter: AnyAddNewLocationPresenter? { get set }
}

class AddNewLocationView: UIViewController, AnyAddNewLocationView {
    var presenter: AnyAddNewLocationPresenter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundColor
    }
}
