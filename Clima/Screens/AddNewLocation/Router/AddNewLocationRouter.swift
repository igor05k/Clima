//
//  AddNewLocationRouter.swift
//  Clima
//
//  Created by Igor Fernandes on 02/03/23.
//

import Foundation

protocol AnyAddNewLocationRouter: AnyObject {
    var view: AnyAddNewLocationView? { get set }
}

class AddNewLocationRouter: AnyAddNewLocationRouter {
    var view: AnyAddNewLocationView?
}
