//
//  StepTwoViewModel.swift
//  WeatherApp
//
//  Created by MOHAMED REBIN K on 04/03/23.
//

import Foundation
import CoreLocation

protocol StepTwoViewModelDelegate: AnyObject{
    func reloadData()
}

class StepTwoViewModel: NSObject{
    
    let locationManager = CLLocationManager()
    var delegate: StepTwoViewModelDelegate?
    
    var weatherData: [[Forecast]] = []{
        didSet{
            cityName = weatherData.first?.first?.cityName ?? "NA"
            delegate?.reloadData()
        }
    }
    var cityName = ""
    
    var currentLocation: CLLocation? {
        didSet{
            getWeatherDetails(lat: "\(currentLocation?.coordinate.latitude ?? 0)", long: "\(currentLocation?.coordinate.longitude ?? 0)")
        }
    }

    func getCurrentLocation(){
        AppUtils.shared.showHUD()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func getWeatherDetails(lat: String, long: String){
        locationManager.stopUpdatingLocation()
        Task{
            defer{AppUtils.shared.hideHUD()}
            do{
                let forecastDetails = try await NetworkManager.shared.getForecast(lat: lat, long: long)
                self.cityName = forecastDetails?.city?.name ?? ""
                self.weatherData = await CoreDataUtils.shared.saveAllWeatherForecast(forecastModel: forecastDetails?.sortedListByDay ?? [], city: self.cityName)?.compactMap{$0.compactMap{$0}} ?? []
            } catch {
                AppUtils.showErrorSnackbar(message: "API Call failed")
                Task{
                    do{
                        let currentWeather = try await CoreDataUtils.shared.getAllForecast()
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd"
                        let grouped = Dictionary(grouping: currentWeather ) { dateFormatter.string(from: $0.date ?? Date()) }
                        let sortedKeys = grouped.keys.sorted()
                        let soretedDate = sortedKeys.compactMap { grouped[$0] }
                        self.weatherData = soretedDate
                    }catch {
                        debugPrint(error.localizedDescription)
                    }
                }
                debugPrint(error.localizedDescription)
            }
        }
    }
}

extension StepTwoViewModel: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let distanceInMeters = location.distance(from: currentLocation ?? CLLocation.init(latitude: 0, longitude: 0))
        if distanceInMeters < 100000 {
            //The two locations are less than 100km apart
        } else {
            //The two locations are more than 100km apart
            currentLocation = location
        }
        print("Current location: \(location.coordinate.latitude), \(location.coordinate.longitude)")
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get location: \(error.localizedDescription)")
    }
}
