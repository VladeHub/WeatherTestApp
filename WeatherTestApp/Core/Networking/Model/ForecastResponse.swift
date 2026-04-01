//
//  ForecastResponse.swift
//  WeatherTestApp
//

import Foundation

struct ForecastResponse: Decodable {
    let forecast: Forecast

    struct Forecast: Decodable {
        let forecastday: [ForecastDay]
    }

    struct ForecastDay: Decodable, Identifiable {
        let date: String
        let day: Day
        let hour: [Hour]
        
        var id: String { date } //sui
    }

    struct Day: Decodable {
        let avgtempC: Double
        let condition: Condition
    }

    struct Hour: Decodable, Identifiable {
        let time: String
        let tempC: Double
        let condition: Condition
        
        var id: String { time } //sui
    }

    struct Condition: Decodable {
        let text: String
        let icon: String
    }
}

