//
//  NetworkError.swift
//  WeatherTestApp
//

// MARK: - Errors
enum NetworkError: Error {
    case badUrl, badResponse, decodingFailed
}
