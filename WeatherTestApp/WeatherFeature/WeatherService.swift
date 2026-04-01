//
//  WeatherService.swift
//  WeatherTestApp
//

import Foundation

protocol WeatherServiceProtocol {
    func getWeatherData() async throws -> (current: CurrentWeatherResponse,
                                           forecast: ForecastResponse)
}

final class WeatherService: WeatherServiceProtocol {
    func getWeatherData() async throws -> (current: CurrentWeatherResponse,
                                           forecast: ForecastResponse) {
        
        let current = try await APIClient.currentWeather()
        let forecast = try await APIClient.forecast()
        
        return (current, forecast)
    }
}
