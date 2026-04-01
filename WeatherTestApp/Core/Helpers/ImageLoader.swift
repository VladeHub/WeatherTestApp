//
//  ImageLoader.swift
//  WeatherTestApp
//

import UIKit

final class ImageLoader {
    
    // MARK: - Singleton
    static let shared = ImageLoader()
    private init() {}
    
    // MARK: - Cache
    private let cache = NSCache<NSString, UIImage>()
    
    // MARK: - Public Methods
    func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        // Проверяем кэш
        let cacheKey = url.absoluteString as NSString
        if let cachedImage = cache.object(forKey: cacheKey) {
            completion(cachedImage)
            return
        }
        
        // Загружаем изображение
        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let data = data, error == nil,
                  let image = UIImage(data: data) else {
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            
            // Сохраняем в кэш
            self?.cache.setObject(image, forKey: cacheKey)
            
            DispatchQueue.main.async {
                completion(image)
            }
        }.resume()
    }
    
    func loadImage(from urlString: String, completion: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        loadImage(from: url, completion: completion)
    }
    
    func loadImage(into imageView: UIImageView, from url: URL, placeholder: UIImage? = nil) {
        imageView.image = placeholder
        
        loadImage(from: url) { [weak imageView] image in
            imageView?.image = image
        }
    }
    
    func loadImage(into imageView: UIImageView, from urlString: String, placeholder: UIImage? = nil) {
        guard let url = URL(string: urlString) else {
            imageView.image = placeholder
            return
        }
        loadImage(into: imageView, from: url, placeholder: placeholder)
    }
    
    func prefetchImages(from urls: [URL]) {
        for url in urls {
            let cacheKey = url.absoluteString as NSString
            if cache.object(forKey: cacheKey) != nil {
                continue
            }
            
            URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
                guard let data = data, error == nil,
                      let image = UIImage(data: data) else {
                    return
                }
                self?.cache.setObject(image, forKey: cacheKey)
            }.resume()
        }
    }
    
    func clearCache() {
        cache.removeAllObjects()
    }
    
    func removeImage(for url: URL) {
        let cacheKey = url.absoluteString as NSString
        cache.removeObject(forKey: cacheKey)
    }
}

// MARK: - UIImageView Extension
extension UIImageView {
    func loadImage(from urlString: String, placeholder: UIImage? = nil) {
        ImageLoader.shared.loadImage(into: self, from: urlString, placeholder: placeholder)
    }
    
    func loadImage(from url: URL, placeholder: UIImage? = nil) {
        ImageLoader.shared.loadImage(into: self, from: url, placeholder: placeholder)
    }
}
