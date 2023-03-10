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
    func retrieveValues() -> [CityInfo]?
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
            
            do {
                try context.save()
                presenter?.didSaveInfo()
            } catch {
                // error handling
                print("error while trying to save data into coredata", error)
            }
        }
    }
    
    // MARK: Isso vai estar no interactor de Locations
    func retrieveValues() -> [CityInfo]? {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let context = appDelegate.persistentContainer.viewContext
            
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "CityEntity")
            
            do {
                let results = try context.fetch(fetchRequest)
                var list: [CityInfo] = [CityInfo]()
                
                for result in results {
                    if let name = result.value(forKey: "name") as? String,
                       let temp = result.value(forKey: "temperature") as? Int,
                       let icon = result.value(forKey: "icon") as? String {
                        list.append(CityInfo(name: name, temp: temp, icon: icon))
                    }
                }
                
                return list
            } catch {
                // error handling
                print("error while retrieving data back from core data", error)
                return nil
            }
        }
        
        return nil
    }
}
