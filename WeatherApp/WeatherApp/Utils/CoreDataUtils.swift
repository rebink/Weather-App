//
//  CoreDataUtils.swift
//  WeatherApp
//
//  Created by MOHAMED REBIN K on 04/03/23.
//

import UIKit
import CoreData

class CoreDataUtils {
    
    // MARK: - Core Data stack
    
    static var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "WeatherApp")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    static var managedObjectContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    // MARK: - Core Data saving
    
    static func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    // MARK: - CRUD operations
    
    static func saveCityWeather(weatherModel: WeatherResponse)async throws -> CurrentWeather? {
        return try await withCheckedThrowingContinuation { continuation in
            let context = managedObjectContext
            if let weather = NSEntityDescription.insertNewObject(forEntityName: "CurrentWeather", into: context) as? CurrentWeather {
                weather.cityName = weatherModel.name
                weather.date = weatherModel.date
                weather.windSpeed = "\(weatherModel.wind?.speed ?? 0)"
                weather.minTemp = "\(weatherModel.main?.temp_min ?? 0)"
                weather.maxTemp = "\(weatherModel.main?.temp_max ?? 0)"
                do {
                    try context.save()
                    continuation.resume(returning: weather)
                } catch {
                    continuation.resume(throwing: error)
                }
            }
            continuation.resume(returning: nil)
        }
    }
    
    static func getAllCityWeather()async throws -> [CurrentWeather] {
        return try await withCheckedThrowingContinuation { continuation in
            let context = managedObjectContext
            let fetchRequest = NSFetchRequest<CurrentWeather>(entityName: "CurrentWeather")
            do {
                let weatherDetails = try context.fetch(fetchRequest)
                continuation.resume(returning: weatherDetails)
            } catch {
                fatalError("Failed to fetch persons: \(error)")
                continuation.resume(throwing: error)
            }
        }
    }
    
    static func deleteAllCityWeatherData()async throws {
        return try await withCheckedThrowingContinuation { continuation in
            let context = persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CurrentWeather")
            let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            do {
                try context.execute(batchDeleteRequest)
                try context.save()
                continuation.resume()
            } catch {
                print("Failed to delete all data: \(error)")
                continuation.resume(throwing: error)
            }
        }
    }
    
}

