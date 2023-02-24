//
//  HomeInteractor.swift
//  Clima
//
//  Created by Igor Fernandes on 23/02/23.
//

import Foundation

protocol AnyHomeInteractor: AnyObject {
    var presenter: AnyHomePresenter? { get set }
}

class HomeInteractor: AnyHomeInteractor {
    var presenter: AnyHomePresenter?
    
}
