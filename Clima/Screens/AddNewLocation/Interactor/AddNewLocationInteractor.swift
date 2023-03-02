//
//  AddNewLocationInteractor.swift
//  Clima
//
//  Created by Igor Fernandes on 02/03/23.
//

import Foundation

protocol AnyAddNewLocationInteractor {
    var presenter: AnyAddNewLocationPresenter? { get set }
}

class AddNewLocationInteractor: AnyAddNewLocationInteractor {
    var presenter: AnyAddNewLocationPresenter?
}
