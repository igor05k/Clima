//
//  LocationsInteractor.swift
//  Clima
//
//  Created by Igor Fernandes on 07/03/23.
//

import UIKit
import CoreData

protocol AnyLocationsInteractor {
    var presenter: LocationsPresenter? { get set }
    func retrieveValues()
    func delete(item: CityInfo, id: Int)
}

class LocationsInteractor: AnyLocationsInteractor {
    var presenter: LocationsPresenter?
    
    func retrieveValues() {
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
                
                presenter?.didFetchCities(data: list)
            } catch {
                // error handling
                print("error while retrieving data back from core data", error)
            }
        }
    }
    
    func delete(item: CityInfo, id: Int) {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let context = appDelegate.persistentContainer.viewContext
            
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "CityEntity")
            
            do {
                let results = try context.fetch(fetchRequest)
                
                for result in results {
                    if let name = result.value(forKey: "name") as? String,
                       let temp = result.value(forKey: "temperature") as? Int,
                       let icon = result.value(forKey: "icon") as? String {
                        
                        if name == item.name && temp == item.temp && icon == item.icon {
                            context.delete(result)
                            presenter?.didDeleteItem(id: id)
                        }
                    }
                }
                
                try context.save()
                
            } catch {
                // error handling
                print("error while retrieving data back from core data", error)
            }
        }
    }
}


