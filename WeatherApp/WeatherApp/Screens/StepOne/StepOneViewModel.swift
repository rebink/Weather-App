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
    
    var weatherData: [WeatherResponse] = [] {
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
                    self.weatherData = weatherDetails.compactMap { $0 }
                } catch {
                    AppUtils.showErrorSnackbar(message: "API Call failed")
                    debugPrint(error.localizedDescription)
                }
            }
        }
    }
    
    private func validateUserEnteredCities(_ citiesCount: Int) -> Bool{
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
