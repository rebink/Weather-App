//
//  StepOneViewModel.swift
//  WeatherApp
//
//  Created by MOHAMED REBIN K on 04/03/23.
//

import Foundation

protocol StepOneViewModelDelegate: AnyObject{
    func reloadData()
}

class StepOneViewModel {
    weak var delegate: StepOneViewModelDelegate?
    
    var weatherData: [CurrentWeather] = [] {
        didSet{
            delegate?.reloadData()
        }
    }
    
    func getWeatherDetailsForCities(_ citiesString: String) {
        Task{
            defer{AppUtils.shared.hideHUD()}
            AppUtils.shared.showHUD()
            //split string to array and remove empty values
            let stringArray = citiesString.split(separator: ",").map { $0.replacingOccurrences(of: "\\s", with: "", options: .regularExpression) }.filter { !$0.isEmpty }
            if validateUserEnteredCities(stringArray.count){
                do{
                    let weatherDetails = try await NetworkManager.shared.getCurrentWeatherForCities(cities: stringArray)
                    Task{
                        self.weatherData = (try? await CoreDataUtils.shared.saveAllCityWeather(weatherModel: weatherDetails.compactMap{$0})?.compactMap{$0}) ?? []
                    }
                } catch {
                    AppUtils.showErrorSnackbar(message: "API Call failed. Checking if data available in cache")
                    Task{
                        do{
                            let currentWeather = try await CoreDataUtils.shared.getAllCityWeatherWith(cities:stringArray)
                            self.weatherData = currentWeather
                        }catch {
                            debugPrint(error.localizedDescription)
                        }
                    }
                    debugPrint(error.localizedDescription)
                }
            }
        }
    }
    
    func validateUserEnteredCities(_ citiesCount: Int) -> Bool{
        //Validation conditions
        let minCitiesCount = 3
        let maxCitiesCount = 7
        
        if citiesCount >= minCitiesCount && citiesCount <= maxCitiesCount {
            return true
        } else {
            AppUtils.showErrorSnackbar(withTitle: "Validation failed", message: "There should be minimum 3 cities and upto max 7 cities")
            return false
        }
    }
}
