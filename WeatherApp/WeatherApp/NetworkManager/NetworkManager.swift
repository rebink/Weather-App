//
//  NetworkManager.swift
//  WeatherApp
//
//  Created by MOHAMED REBIN K on 04/03/23.
//

import Foundation
import Moya
import Alamofire


protocol Networkable {
    var provider: MoyaProvider<API> { get }
    //General function
    func request<T: Decodable>(_ type: T.Type,target: API)async throws -> T

    //Custom API's
    func getCurrentWeatherForCities(cities: [String]) async throws -> [WeatherResponse?]
    func getForecast(lat: String,long:String) async throws -> ForecastResponse?
}

enum NetworkError: Error {
    case noInternetConnection
    case requestFailed
}

class NetworkManager: Networkable {
    let provider = MoyaProvider<API>(plugins: [NetworkLoggerPlugin()])
    static let shared = NetworkManager()
    private init() {}
    let internetStatus = NetworkReachabilityManager()
    
    func getCurrentWeatherForCities(cities: [String]) async throws -> [WeatherResponse?]{
        guard let status = internetStatus,status.isReachable else {
            throw NetworkError.noInternetConnection
        }
        return await withTaskGroup(of: WeatherResponse?.self,returning: [WeatherResponse?].self) { group in
            for city in cities {
                group.addTask {
                    try? await self.request(WeatherResponse.self, target: API.getCurrentWeatherDetailsForCity(city: city))
                }
            }
            var responses: [WeatherResponse?] = []
            for await result in group {
                responses.append(result)
            }
            return responses
        }
    }
    
    func getForecast(lat: String,long:String) async throws -> ForecastResponse?{
        guard let status = internetStatus,status.isReachable else {
            throw NetworkError.noInternetConnection
        }
        do{
            return try await request(ForecastResponse?.self, target: API.getForecast(lat: lat, long: long))
        }catch{
            throw error
        }
    }
}

extension NetworkManager {
    func request<T: Decodable>(_ type: T.Type,target: API) async throws -> T {
        return try await withCheckedThrowingContinuation { continuation in
            provider.request(target) { result in
                switch result {
                case let .success(response):
                    do {
                        let results = try JSONDecoder().decode(T.self, from: response.data)
                        continuation.resume(with: .success(results))
                    } catch let error {
                        continuation.resume(with: .failure(error))
                    }
                case let .failure(error):
                    continuation.resume(with: .failure(error))
                }
            }
        }
    }
}
