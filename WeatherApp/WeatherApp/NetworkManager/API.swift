//
//  API.swift
//  WeatherApp
//
//  Created by MOHAMED REBIN K on 04/03/23.
//

import Foundation
import Moya

enum API {
    case getCurrentWeatherDetailsForCity(city: String)
    case getForecast(lat:String, long:String)
}

extension API: TargetType {
    var baseURL: URL {
        return URL(string: "https://api.openweathermap.org/")!
    }
    
    var path: String {
        switch self{
        case .getCurrentWeatherDetailsForCity(city: _):
            return "data/2.5/weather"
        case .getForecast(lat: _, long: _):
            return "data/2.5/forecast"
        }
    }
    
    var method: Moya.Method {
        switch self{
        case .getCurrentWeatherDetailsForCity(city: _):
            return .get
        case .getForecast(lat: _, long: _):
            return .get
        }
    }
    
    var task: Moya.Task {
        let apiKey = Bundle.main.infoDictionary?["OpenWeather_API_KEY"] as? String ?? ""
        switch self{
        case .getCurrentWeatherDetailsForCity(city: let city):
            return .requestParameters(parameters: ["q": city, "appid":apiKey, "units": "metric"], encoding: URLEncoding.queryString)
        case .getForecast(lat: let lat, long: let long):
            return .requestParameters(parameters: ["lat": lat, "lon":long, "appid": apiKey, "units": "metric"], encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        switch self{
        case .getCurrentWeatherDetailsForCity(city: _):
            return ["Content-Type": "application/json"]
        case .getForecast(lat: _, long: _):
            return ["Content-Type": "application/json"]
        }
    }
    
}
