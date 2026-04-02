//
//  WeatherViewModel.swift
//  WeatherTestApp
//

import Foundation
internal import Combine

@MainActor
final class WeatherViewModel: ObservableObject {
    @Published var currentWeather: CurrentWeatherResponse?
    @Published var forecast: ForecastResponse?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let weatherService = WeatherService()
    
    func loadWeather() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let (current, forecast) = try await weatherService.getWeatherData()
            
            self.currentWeather = current
            self.forecast = forecast
            
        } catch {
            errorMessage = error.localizedDescription
            print("Ошибка загрузки: \(error)")
        }
    }
}
