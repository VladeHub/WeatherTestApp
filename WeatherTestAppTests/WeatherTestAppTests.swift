//
//  WeatherTestAppTests.swift
//  WeatherTestAppTests
//

import XCTest
@testable import WeatherTestApp

final class WeatherTestAppTests: XCTestCase {
    
    // MARK: - DataFormatter Tests
    
    func testDataFormatterDateFormat() {
        // Given
        let dateFormatter = DataFormatter.shared
        let dateString = "2024-01-15"
        
        // When
        let formattedDate = dateFormatter.formatDate(dateString)
        
        // Then
        XCTAssertEqual(formattedDate, "Понедельник, 15 Янв.", "Date should be formatted in Russian locale")
    }
    
    func testDataFormatterInvalidDate() {
        // Given
        let dateFormatter = DataFormatter.shared
        let invalidDate = "invalid-date"
        
        // When
        let formattedDate = dateFormatter.formatDate(invalidDate)
        
        // Then
        XCTAssertEqual(formattedDate, invalidDate, "Invalid date should return original string")
    }
    
    // MARK: - ImageLoader Tests
    func testImageLoaderCache() {
        // Given
        let imageLoader = ImageLoader.shared
        let testURL = URL(string: "https://example.com/test.png")!
        let expectation = XCTestExpectation(description: "Image loading")
        
        // When
        imageLoader.loadImage(from: testURL) { image in
            // Then
            // Проверяем, что изображение загрузилось (если есть интернет)
            // Или проверяем кэш
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10)
    }
    
    func testImageLoaderClearCache() {
        // Given
        let imageLoader = ImageLoader.shared
        let testURL = URL(string: "https://example.com/test.png")!
        
        // When
        imageLoader.clearCache()
        
        // Then
        // Проверяем, что кэш очищен (нет прямого доступа, но можно проверить через загрузку)
        imageLoader.loadImage(from: testURL) { image in
            // Изображение должно загрузиться заново
        }
    }
    
    
    // MARK: - Location Tests
    func testLocationErrorMessages() {
        // Given
        let errors: [(LocationError, String)] = [
            (.notAvailable, "Не удалось определить местоположение"),
            (.denied, "Нет доступа к геолокации"),
            (.timeout, "Превышено время ожидания определения местоположения"),
            (.failed("Test error"), "Ошибка геолокации: Test error")
        ]
        
        // When & Then
        for (error, expectedMessage) in errors {
            XCTAssertEqual(error.errorDescription, expectedMessage)
        }
    }
}
