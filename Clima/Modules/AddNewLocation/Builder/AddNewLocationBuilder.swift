//
//  AddNewLocationBuilder.swift
//  Clima
//
//  Created by Igor Fernandes on 08/03/23.
//

import UIKit

class AddNewLocation {
    static func build() -> UIViewController {
        let view = AddNewLocationView()
        let interactor = AddNewLocationInteractor()
        let router = AddNewLocationRouter()
        let presenter = AddNewLocationPresenter(view: view, interactor: interactor, router: router)

        view.presenter = presenter
        router.view = view
        interactor.presenter = presenter

        return view
    }
}


