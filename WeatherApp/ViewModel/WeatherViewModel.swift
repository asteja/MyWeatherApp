//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by Saiteja Alle on 8/17/20.
//  Copyright © 2020 Saiteja Alle. All rights reserved.
//

import Foundation
import UIKit.UIApplication
import CoreData

class WeatherViewModel: NSObject {
    
    var weatherData:Box<[NSManagedObject]?> = Box(nil)
    var error:Box<APIError?> = Box(nil)
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    func getBriefWeatherDetails(for zipCode: String?) {
        guard !checkIfRecordExists(zipCode: zipCode) else {
            self.error.value = APIError.dataExistsError
            return
        }
        let weatherClient = WeatherClient()
        weatherClient.startLoad(zipCode: zipCode) { (weatherData, apiError) in
            self.saveData(weatherData: weatherData, zipCode: zipCode)
            self.fetchData()
            self.error.value = apiError
        }
    }
    
    //MARK: CORE DATA OPERATIONS
    
    func saveData(weatherData: WeatherData?, zipCode: String?) {
        guard let weatherData = weatherData, let zipCode = zipCode else {
            self.error.value = APIError.dataSaveError
            return
        }
        
        let entity = NSEntityDescription.entity(forEntityName: "Weather", in: appDelegate.persistentContainer.viewContext)
        let weatherObject = NSManagedObject(entity: entity!, insertInto: appDelegate.persistentContainer.viewContext)
        weatherObject.setValue(zipCode, forKey: "zipCode")
        weatherObject.setValue(weatherData.city, forKey: "city")
        weatherObject.setValue(weatherData.tempData?["temp"], forKey: "temp")
        appDelegate.saveContext()
    }

    func fetchData() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Weather")
        request.returnsObjectsAsFaults = false
        do {
            if let result = try appDelegate.persistentContainer.viewContext.fetch(request) as? [NSManagedObject] {
                self.weatherData.value = result
            }
        } catch {
            self.error.value = APIError.dataFetchError
            print("Fetching data Failed")
        }
    }
    
    func checkIfRecordExists(zipCode: String?) -> Bool {
        guard let zipCode = zipCode else {
            return false
        }
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Weather")
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "zipCode == %@", zipCode)
        if let results = try? appDelegate.persistentContainer.viewContext.count(for: request) {
            return results != 0
        }else {
            return false
        }
    }
}
