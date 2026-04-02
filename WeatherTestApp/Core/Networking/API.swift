//
//  API.swift
//  WeatherTestApp
//

import CoreLocation
import Foundation

struct APIClient {
    private static let apiKey = "fa8b3df74d4042b9aa7135114252304"
    private static let baseURL = "http://api.weatherapi.com/v1/"
    private static let moscowCoordinates = "55.7558,37.6173"
    
    static func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T {
     
        let query = await getLocationQuery()
        
        var components = URLComponents(string: baseURL + endpoint.rawValue)
        var items = [
            URLQueryItem(name: "key", value: apiKey),
            URLQueryItem(name: "q", value: query),
            URLQueryItem(name: "lang", value: "ru")
        ]
        
        if endpoint == .forecast {
            items.append(URLQueryItem(name: "days", value: "3"))
        }
        
        components?.queryItems = items
        
        guard let url = components?.url else {
            throw NetworkError.badUrl
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.badResponse
            }
            
            guard 200..<300 ~= httpResponse.statusCode else {
                // Выводим ошибку от сервера для диагностики
                if let errorString = String(data: data, encoding: .utf8) {
                    print("❌ Server error response: \(errorString)")
                }
                throw NetworkError.badResponse
            }
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            do {
                let result = try decoder.decode(T.self, from: data)
                return result
            } catch {
                print("❌ Decoding error: \(error)")
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("📄 JSON response: \(jsonString)")
                }
                throw NetworkError.decodingFailed
            }
        } catch {
            print("❌ Network error: \(error)")
            throw error
        }
    }
}

// MARK: - Convenience Methods
extension APIClient {
    static func currentWeather() async throws -> CurrentWeatherResponse {
        try await request(.current)
    }
    
    static func forecast() async throws -> ForecastResponse {
        try await request(.forecast)
    }
}

// MARK: - Private Methods
private extension APIClient {
    static func getLocationQuery() async -> String {
        // Проверяем, есть ли доступ к геолокации
        let status = LocationManager.shared.getAuthorizationStatus()
        
        if status == .denied || status == .restricted {
            print("⚠️ Location access denied, using Moscow")
            return moscowCoordinates
        }
        
        do {
            let coordinate = try await LocationManager.shared.getCurrentLocation()
            return "\(coordinate.latitude),\(coordinate.longitude)"
        } catch {
            print("⚠️ Failed to get location: \(error.localizedDescription)")
            print("📍 Using Moscow coordinates as fallback")
            return moscowCoordinates
        }
    }
}
