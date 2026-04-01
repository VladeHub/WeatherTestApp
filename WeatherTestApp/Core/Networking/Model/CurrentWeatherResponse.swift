//
//  CurrentWeatherResponse.swift
//  WeatherTestApp
//

import Foundation

struct CurrentWeatherResponse: Decodable {
    let location: Location
    let current: Current

    struct Location: Decodable {
        let name: String?
        let lat: Double?
        let lon: Double?
        let country: String?
    }

    struct Current: Decodable {
        let tempC: Double?
        let condition: Condition?
        let windKph: Double?
        let humidity: Int?

        struct Condition: Decodable {
            let text: String?
            let icon: String?
        }
    }
}

