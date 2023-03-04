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
}

extension API: TargetType {
    var baseURL: URL {
        return URL(string: "https://api.openweathermap.org/")!
    }
    
    var path: String {
        switch self{
        case .getCurrentWeatherDetailsForCity(city: _):
            return "data/2.5/weather"
        }
    }
    
    var method: Moya.Method {
        switch self{
        case .getCurrentWeatherDetailsForCity(city: _):
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self{
        case .getCurrentWeatherDetailsForCity(city: let city):
            let apiKey = Bundle.main.infoDictionary?["OpenWeather_API_KEY"] as? String ?? ""
            return .requestParameters(parameters: ["q": city, "appid":apiKey, "units": "metric"], encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        switch self{
        case .getCurrentWeatherDetailsForCity(city: _):
            return ["Content-Type": "application/json"]
        }
    }
    
    
}
