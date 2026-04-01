//
//  DataFormatter.swift
//  WeatherTestApp
//

import Foundation

final class DataFormatter {
    
    // MARK: - Singleton
    static let shared = DataFormatter()
    private init() {}
    
    // MARK: - Private Formatters
    private let hourInputFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        return formatter
    }()
    
    private let hourOutputFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }()
    
    private let dateInputFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    private let dateOutputFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "EEEE, d MMM"
        return formatter
    }()
    
    // MARK: - Public Methods
    func formatHour(_ timeString: String) -> String {
        guard let date = hourInputFormatter.date(from: timeString) else {
            return timeString
        }
        return hourOutputFormatter.string(from: date)
    }
    
    func formatDate(_ dateString: String) -> String {
        guard let date = dateInputFormatter.date(from: dateString) else {
            return dateString
        }
        return dateOutputFormatter.string(from: date).capitalized
    }
    
    func formatDateShort(_ dateString: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        guard let date = formatter.date(from: dateString) else {
            return dateString
        }
        
        formatter.dateFormat = "dd.MM"
        return formatter.string(from: date)
    }
    
    func formatDateTime(_ dateString: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "dd.MM HH:mm"
        
        guard let date = inputFormatter.date(from: dateString) else {
            return dateString
        }
        
        return outputFormatter.string(from: date)
    }
    
    func formatDayOfWeek(_ dateString: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"
        
        let outputFormatter = DateFormatter()
        outputFormatter.locale = Locale(identifier: "ru_RU")
        outputFormatter.dateFormat = "EEEE"
        
        guard let date = inputFormatter.date(from: dateString) else {
            return dateString
        }
        
        return outputFormatter.string(from: date).capitalized
    }
}
