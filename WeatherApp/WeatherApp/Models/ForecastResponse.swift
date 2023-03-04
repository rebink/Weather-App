
//
//  ForecastResponse.swift
//  WeatherApp
//
//  Created by MOHAMED REBIN K on 04/03/23.
//

import Foundation


struct ForecastResponse: Codable {
    let cod: String?
    let message: Int?
    let cnt: Int?
    let list: [ForecastData]?
    let city: City?
    
    struct ForecastData: Codable {
        let dt: TimeInterval?
        let main: Main?
        let weather: [WeatherInfo]?
        let clouds: Clouds?
        let wind: Wind?
        let visibility: Int?
        let pop: Double?
        let sys: Sys?
        let dt_txt: String?
        
        struct Main: Codable {
            let temp: Double?
            let feels_like: Double?
            let temp_min: Double?
            let temp_max: Double?
            let pressure: Int?
            let sea_level: Int?
            let grnd_level: Int?
            let humidity: Int?
            let temp_kf: Double?
        }
        
        struct WeatherInfo: Codable {
            let id: Int?
            let main: String?
            let description: String?
            let icon: String?
        }
        
        struct Clouds: Codable {
            let all: Int?
        }
        
        struct Wind: Codable {
            let speed: Double?
            let deg: Int?
            let gust: Double?
        }
        
        struct Sys: Codable {
            let pod: String?
        }
        
        var date: Date {
            return Date(timeIntervalSince1970: dt ?? TimeInterval())
        }
        
        enum CodingKeys: String, CodingKey {
            case dt, main, weather, clouds, wind, visibility, pop, sys, dt_txt
        }
    }
    
    var sortedListByDay: [[ForecastData]] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let grouped = Dictionary(grouping: list ?? []) { dateFormatter.string(from: $0.date) }
        let sortedKeys = grouped.keys.sorted()
        return sortedKeys.compactMap { grouped[$0] }
    }
    
    enum CodingKeys: String, CodingKey {
        case cod, message, cnt, list, city
    }
    
    struct City: Codable {
        let id: Int?
        let name: String?
        let coord: Coordinate?
        let country: String?
        let population: Int?
        let timezone: Int?
        let sunrise: Int?
        let sunset: Int?
    }

    struct Coordinate: Codable {
        let lat: Double?
        let lon: Double?
    }
}

