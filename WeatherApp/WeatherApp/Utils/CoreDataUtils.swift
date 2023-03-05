//
//  CoreDataUtils.swift
//  WeatherApp
//
//  Created by MOHAMED REBIN K on 04/03/23.
//

import UIKit
import CoreData

class CoreDataUtils {
    static var shared = CoreDataUtils()
    private init() {}
    
    // MARK: - Core Data stack
    
    var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "WeatherApp")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    var managedObjectContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    // MARK: - Core Data saving
    
    func saveContext () {
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
    
    func saveAllCityWeather(weatherModel: [WeatherResponse]) async throws -> [CurrentWeather?]?{
        try? await deleteAllOldCityWeatherData()
        var responses: [CurrentWeather?] = []
        for model in weatherModel {
            try? await deleteAllOldCityWeatherData(city: model.name ?? "")
            responses.append(try? await saveCityWeather(weatherModel: model))
        }
        return responses
    }
    
    func saveCityWeather(weatherModel: WeatherResponse)async throws -> CurrentWeather? {
        return try await withCheckedThrowingContinuation { continuation in
            let context = managedObjectContext
            if let weather = NSEntityDescription.insertNewObject(forEntityName: "CurrentWeather", into: context) as? CurrentWeather {
                weather.cityName = weatherModel.name
                weather.date = weatherModel.date
                weather.windSpeed = "\(weatherModel.wind?.speed ?? 0)"
                weather.minTemp = "\(weatherModel.main?.temp_min ?? 0)"
                weather.maxTemp = "\(weatherModel.main?.temp_max ?? 0)"
                weather.weatherDescription = weatherModel.weather?.first?.description
                weather.icon = weatherModel.weather?.first?.icon
                do {
                    try context.save()
                    context.refresh(weather, mergeChanges: true)
                    continuation.resume(returning: weather)
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    func getAllCityWeather()async throws -> [CurrentWeather] {
        return try await withCheckedThrowingContinuation { continuation in
            let context = managedObjectContext
            let fetchRequest = NSFetchRequest<CurrentWeather>(entityName: "CurrentWeather")
            do {
                let weatherDetails = try context.fetch(fetchRequest)
                continuation.resume(returning: weatherDetails)
            } catch {
                continuation.resume(throwing: error)
            }
        }
    }
    
    func getAllCityWeatherWith( cities: [String])async throws -> [CurrentWeather] {
        return try await withCheckedThrowingContinuation { continuation in
            let context = managedObjectContext
            let fetchRequest = NSFetchRequest<CurrentWeather>(entityName: "CurrentWeather")
            let currentDate = Date()
            let threeHoursAgo = Calendar.current.date(byAdding: .hour, value: -3, to: currentDate) ?? Date()
            let datePredicate = NSPredicate(format: "date > %@", threeHoursAgo as NSDate)
            var cityPredicate = cities.map { name in
                NSPredicate(format: "cityName CONTAINS[c] %@", name)
            }
            let compoundPredicate = NSCompoundPredicate(type: .or, subpredicates:  cityPredicate)
            let finalPredicate = NSCompoundPredicate(type: .and, subpredicates: [compoundPredicate,datePredicate])
            fetchRequest.predicate = finalPredicate
            do {
                let weatherDetails = try context.fetch(fetchRequest)
                continuation.resume(returning: weatherDetails)
            } catch {
                continuation.resume(throwing: error)
            }
        }
    }
    
    func deleteAllOldCityWeatherData()async throws {
        return try await withCheckedThrowingContinuation { continuation in
            let context = persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CurrentWeather")
            let currentDate = Date()
            let threeHoursAgo = Calendar.current.date(byAdding: .hour, value: -3, to: currentDate) ?? Date()
            fetchRequest.predicate = NSPredicate(format: "date < %@", threeHoursAgo as NSDate)
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
    
    func deleteAllOldCityWeatherData(city: String)async throws {
        return try await withCheckedThrowingContinuation { continuation in
            let context = persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CurrentWeather")
            fetchRequest.predicate = NSPredicate(format: "cityName == %@", city)
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


//Forecast
extension CoreDataUtils {
    
    func saveAllWeatherForecast(forecastModel: [[ForecastResponse.ForecastData]], city: String) async -> [[Forecast?]]? {
        try? await deleteAllOldForecastData()
        var forecasts: [[Forecast?]] = []
        for dayForecast in forecastModel {
            var dayForecastArray: [Forecast?] = []
            for model in dayForecast {
                let forecast = try? await saveForecastWeather(forecastModel: model, city: city)
                dayForecastArray.append(forecast)
            }
            forecasts.append(dayForecastArray)
        }
        return forecasts
    }
    
    func saveForecastWeather(forecastModel: ForecastResponse.ForecastData, city: String)async throws -> Forecast? {
        return try await withCheckedThrowingContinuation { continuation in
            let context = managedObjectContext
            if let weather = NSEntityDescription.insertNewObject(forEntityName: "Forecast", into: context) as? Forecast {
                weather.cityName = city
                weather.date = forecastModel.date
                weather.windSpeed = "\(forecastModel.wind?.speed ?? 0)"
                weather.minTemp = "\(forecastModel.main?.temp_min ?? 0)"
                weather.maxTemp = "\(forecastModel.main?.temp_max ?? 0)"
                weather.weather = forecastModel.weather?.first?.description
                weather.icon = forecastModel.weather?.first?.icon
                do {
                    try context.save()
                    continuation.resume(returning: weather)
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    func getAllForecast()async throws -> [Forecast] {
        return try await withCheckedThrowingContinuation { continuation in
            let context = managedObjectContext
            let fetchRequest = NSFetchRequest<Forecast>(entityName: "Forecast")
            do {
                let weatherDetails = try context.fetch(fetchRequest)
                continuation.resume(returning: weatherDetails)
            } catch {
                continuation.resume(throwing: error)
            }
        }
    }
    
    func deleteAllOldForecastData()async throws {
        return try await withCheckedThrowingContinuation { continuation in
            let context = persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Forecast")
            let currentDate = Date()
            let threeHoursAgo = Calendar.current.date(byAdding: .hour, value: -3, to: currentDate) ?? Date()
            fetchRequest.predicate = NSPredicate(format: "date < %@", threeHoursAgo as NSDate)
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
