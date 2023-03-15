//
//  LocationsInteractor.swift
//  Clima
//
//  Created by Igor Fernandes on 07/03/23.
//

import UIKit
import CoreData

protocol AnyLocationsInteractor {
    var presenter: AnyLocationsPresenter? { get set }
    func retrieveValues()
    func delete(item: CityInfo, id: Int)
    func updateData(cities: [CityInfo])
}

class LocationsInteractor: AnyLocationsInteractor {
    var presenter: AnyLocationsPresenter?
    
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
                       let icon = result.value(forKey: "icon") as? String,
                       let lat = result.value(forKey: "lat") as? Double,
                       let lon = result.value(forKey: "lon") as? Double {
                        list.append(CityInfo(name: name, temp: temp, icon: icon, lat: lat, lon: lon))
                    }
                }
                
                presenter?.didFetchCities(data: list)
            } catch {
                // error handling
                print("error while retrieving data back from core data", error)
            }
        }
    }
    
    private func updateCoreDataItems(response: CurrentWeatherEntity, city: CityInfo) {
        let updatedName = response.name ?? ""
        let updatedTemp = Int(response.main?.temp?.kelvinToCelsius() ?? 0)
        let updatedIcon = response.weather?[0].icon ?? ""
        let updatedLat = response.coord?.lat ?? 0
        let updatedLon = response.coord?.lon ?? 0
        
        DispatchQueue.main.async { [weak self] in
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                let context = appDelegate.persistentContainer.viewContext

                let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "CityEntity")
                
                do {
                    let results = try context.fetch(fetchRequest)
                    
                    for result in results {
                        if let name = result.value(forKey: "name") as? String,
                           let temp = result.value(forKey: "temperature") as? Int,
                           let icon = result.value(forKey: "icon") as? String,
                           let lat = result.value(forKey: "lat") as? Double,
                           let lon = result.value(forKey: "lon") as? Double {
                            
                            if name == city.name && temp == city.temp && icon == city.icon && city.lat == lat && city.lon == lon {
                                result.setValue(updatedName, forKey: "name")
                                result.setValue(updatedTemp, forKey: "temperature")
                                result.setValue(updatedIcon, forKey: "icon")
                                result.setValue(updatedLat, forKey: "lat")
                                result.setValue(updatedLon, forKey: "lon")
                            }
                        }
                    }
                    
                    try context.save()
                    self?.presenter?.didUpdateData()
                } catch {
                    // error handling
                    print("error while retrieving data back from core data", error)
                }
            }
        }
    }
    
    func updateData(cities: [CityInfo]) {
        for city in cities {
            let latToString = String(city.lat)
            let lonToString = String(city.lon)
            
            guard let url = URL(string: APIConfig.base_URL.rawValue + Endpoints.currentWeather.rawValue + "?lat=\(latToString)&lon=\(lonToString)&appid=" + APIConfig.api_key.rawValue) else { return }
            
            URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
                guard let data, error == nil else { return }
                
                do {
                    let json = try JSONDecoder().decode(CurrentWeatherEntity.self, from: data)
                    self?.updateCoreDataItems(response: json, city: city)
                } catch {
                    print(error)
                }
            }.resume()
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
                       let icon = result.value(forKey: "icon") as? String,
                       let lat = result.value(forKey: "lat") as? Double,
                       let lon = result.value(forKey: "lon") as? Double {
                        
                        if name == item.name && temp == item.temp && icon == item.icon && item.lat == lat && item.lon == lon {
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


/*
 // save into core data
 if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
 let context = appDelegate.persistentContainer.viewContext
 
 guard let entity = NSEntityDescription.entity(forEntityName: "CityEntity", in: context) else { return } // no entity found
 let object = NSManagedObject(entity: entity, insertInto: context)
 
 object.setValue(object.name, forKey: "name")
 object.setValue(object.temp, forKey: "temperature")
 object.setValue(object.icon, forKey: "icon")
 object.setValue(object.lat, forKey: "lat")
 object.setValue(object.lon, forKey: "lon")
 
 do {
 try context.save()
 
 } catch {
 // error handling
 print("error while trying to save data into coredata", error)
 }
 }
 */
