//
//  HomeRouter.swift
//  Clima
//
//  Created by Igor Fernandes on 23/02/23.
//

import UIKit

typealias EntryPoint = AnyHomeView & UIViewController

protocol AnyHomeRouter: AnyObject {
    var view: EntryPoint? { get set }
    
    static func start() -> AnyHomeRouter
}

class HomeRouter: AnyHomeRouter {
    var view: EntryPoint?
    
    static func start() -> AnyHomeRouter {
        let router: AnyHomeRouter = HomeRouter()
        
        let view: AnyHomeView = HomeView()
        let interactor: AnyHomeInteractor = HomeInteractor()
        let presenter: AnyHomePresenter = HomePresenter()
        
        view.presenter = presenter
        
        interactor.presenter = presenter
        
        presenter.interactor = interactor
        presenter.router = router
        presenter.view = view
        
        router.view = view as? HomeView
        
        return router
    }
}
