//
//  HomeRouter.swift
//  Clima
//
//  Created by Igor Fernandes on 23/02/23.
//

import UIKit

protocol AnyHomeRouter: AnyObject {
    var view: HomeView? { get set }
    func goToAddNewLocation()
}

class HomeRouter: AnyHomeRouter {
    weak var view: HomeView?
    
    static func build() -> UIViewController {
        let view = HomeView()
        let interactor = HomeInteractor()
        let router = HomeRouter()
        let presenter = HomePresenter(view: view, interactor: interactor, router: router)

        view.presenter = presenter
        router.view = view
        interactor.presenter = presenter

        return view
    }
    
    func goToAddNewLocation() {
        let addNewLocation = AddNewLocation.build()
        view?.navigationController?.pushViewController(addNewLocation, animated: true)
    }
}
