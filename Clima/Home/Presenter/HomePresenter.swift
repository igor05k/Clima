//
//  HomePresenter.swift
//  Clima
//
//  Created by Igor Fernandes on 23/02/23.
//

import Foundation

protocol AnyHomePresenter: AnyObject {
    var view: AnyHomeView? { get set }
    var interactor: AnyHomeInteractor? { get set }
    var router: AnyHomeRouter? { get set }
}

class HomePresenter: AnyHomePresenter {
    var view: AnyHomeView?
    var interactor: AnyHomeInteractor?
    var router: AnyHomeRouter?
}
