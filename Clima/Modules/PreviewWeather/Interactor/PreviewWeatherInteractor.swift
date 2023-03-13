//
//  PreviewWeatherInteractor.swift
//  Clima
//
//  Created by Igor Fernandes on 10/03/23.
//

import CoreData
import UIKit

protocol AnyPreviewWeatherInteractor {
    var presenter: PreviewWeatherPresenter? { get set }
    
    func save(data: CityInfo)
}

class PreviewWeatherInteractor: AnyPreviewWeatherInteractor {
    var presenter: PreviewWeatherPresenter?
    
    func save(data: CityInfo) {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let context = appDelegate.persistentContainer.viewContext
            
            guard let entity = NSEntityDescription.entity(forEntityName: "CityEntity", in: context) else { return } // no entity found
            let object = NSManagedObject(entity: entity, insertInto: context)
            
            object.setValue(data.name, forKey: "name")
            object.setValue(data.temp, forKey: "temperature")
            object.setValue(data.icon, forKey: "icon")
            object.setValue(data.lat, forKey: "lat")
            object.setValue(data.lon, forKey: "lon")
            
            do {
                try context.save()
                presenter?.didSaveInfo()
            } catch {
                // error handling
                print("error while trying to save data into coredata", error)
            }
        }
    }
}
