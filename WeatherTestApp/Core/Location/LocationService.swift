//
//  Untitled.swift
//  WeatherTestApp
//

import CoreLocation

final class LocationManager: NSObject, CLLocationManagerDelegate {
    static let shared = LocationManager()
    
    private let manager = CLLocationManager()
    private var continuation: CheckedContinuation<CLLocationCoordinate2D, Error>?
    private var timeoutTask: Task<Void, Never>?
    
    private override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func getCurrentLocation() async throws -> CLLocationCoordinate2D {
        // Проверяем статус авторизации
        let status = manager.authorizationStatus
        
        switch status {
        case .denied, .restricted:
            throw LocationError.denied
        case .notDetermined:
            // Запрашиваем разрешение и ждем
            manager.requestWhenInUseAuthorization()
            return try await withCheckedThrowingContinuation { continuation in
                self.continuation = continuation
                setupTimeout()
            }
        case .authorizedWhenInUse, .authorizedAlways:
            // Уже есть разрешение
            return try await withCheckedThrowingContinuation { continuation in
                self.continuation = continuation
                setupTimeout()
                manager.startUpdatingLocation()
            }
        @unknown default:
            throw LocationError.notAvailable
        }
    }
    
    func getAuthorizationStatus() -> CLAuthorizationStatus {
        return manager.authorizationStatus
    }
    
    // MARK: - CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        finish(with: locations.first?.coordinate)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        finish(with: LocationError.failed(error.localizedDescription))
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = manager.authorizationStatus
        
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            print("✅ Location authorization granted")
            // Если есть ожидающий continuation, запускаем обновление
            if continuation != nil {
                manager.startUpdatingLocation()
            }
        case .denied, .restricted:
            print("❌ Location authorization denied")
            finish(with: LocationError.denied)
        default:
            break
        }
    }
}

private extension LocationManager {
    func setupTimeout() {
        timeoutTask = Task {
            try? await Task.sleep(nanoseconds: 600_000_000_000)
            if let continuation = self.continuation {
                print("⏰ Location timeout")
                self.continuation = nil
                self.manager.stopUpdatingLocation()
                continuation.resume(throwing: LocationError.timeout)
            }
            self.timeoutTask = nil
        }
    }
    
    func finish(with coordinate: CLLocationCoordinate2D?) {
        guard let continuation = continuation else { return }
        
        timeoutTask?.cancel()
        timeoutTask = nil
        self.continuation = nil
        manager.stopUpdatingLocation()
        
        if let coordinate = coordinate {
            print("✅ Location obtained: \(coordinate.latitude), \(coordinate.longitude)")
            continuation.resume(returning: coordinate)
        } else {
            print("❌ No location obtained")
            continuation.resume(throwing: LocationError.notAvailable)
        }
    }
    
    func finish(with error: Error) {
        guard let continuation = continuation else { return }
        
        timeoutTask?.cancel()
        timeoutTask = nil
        self.continuation = nil
        manager.stopUpdatingLocation()
        
        print("❌ Location error: \(error)")
        continuation.resume(throwing: error)
    }
}

// MARK: - Errors
enum LocationError: LocalizedError {
    case notAvailable
    case denied
    case timeout
    case failed(String)
    
    var errorDescription: String? {
        switch self {
        case .notAvailable:
            return "Не удалось определить местоположение"
        case .denied:
            return "Нет доступа к геолокации"
        case .timeout:
            return "Превышено время ожидания определения местоположения"
        case .failed(let message):
            return "Ошибка геолокации: \(message)"
        }
    }
}
