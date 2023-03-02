//
//  AddNewLocationPresenter.swift
//  Clima
//
//  Created by Igor Fernandes on 02/03/23.
//

import Foundation

protocol AnyAddNewLocationPresenter: AnyObject {
    var view: AnyAddNewLocationView? { get set }
    var interactor: AnyAddNewLocationInteractor? { get set }
    var presenter: AnyAddNewLocationPresenter? { get set }
}

class AddNewLocationPresenter: AnyAddNewLocationPresenter {
    var view: AnyAddNewLocationView?
    var interactor: AnyAddNewLocationInteractor?
    var presenter: AnyAddNewLocationPresenter?
}
