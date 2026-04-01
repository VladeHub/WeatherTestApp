//
//  CurrentWeatherView.swift
//  WeatherTestApp
//

import UIKit

final class CurrentWeatherView: UIView {
    
    // MARK: - UI Elements
    private let cityLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 24, weight: .semibold)
        label.textAlignment = .center
        label.textColor = .label
        return label
    }()
    
    private let headerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .center
        stackView.distribution = .fill
        return stackView
    }()
    
    private let weatherIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let temperatureLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 60, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    
    private let conditionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let humidityLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16)
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let windLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16)
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        return label
    }()
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configuration
    func configure(with weather: CurrentWeatherResponse) {
        cityLabel.text = weather.location.name ?? "Москва"
        temperatureLabel.text = String(format: "%.1f°C", weather.current.tempC ?? 0)
        conditionLabel.text = weather.current.condition?.text ?? "Нет данных"
        humidityLabel.text = "Влажность: \(weather.current.humidity ?? 0)%"
        windLabel.text = String(format: "Ветер: %.1f км/ч", weather.current.windKph ?? 0)
        
        if let iconURLString = weather.current.condition?.icon,
           let iconURL = URL(string: "https:\(iconURLString)") {
            ImageLoader.shared.loadImage(into: weatherIconImageView, from: iconURL)
        }
    }
}

private extension CurrentWeatherView {
    // MARK: - Setup
    func setupUI() {
        backgroundColor = .systemBackground
        layer.cornerRadius = 16
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.1
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 8
        
        headerStackView.addArrangedSubview(cityLabel)
        headerStackView.addArrangedSubview(weatherIconImageView)
        
        addSubview(headerStackView)
        addSubview(temperatureLabel)
        addSubview(conditionLabel)
        addSubview(humidityLabel)
        addSubview(windLabel)
        
        setupConstraints()
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            
            headerStackView.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            headerStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            temperatureLabel.topAnchor.constraint(equalTo: headerStackView.bottomAnchor, constant: 12),
            temperatureLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            conditionLabel.topAnchor.constraint(equalTo: temperatureLabel.bottomAnchor, constant: 8),
            conditionLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            humidityLabel.topAnchor.constraint(equalTo: conditionLabel.bottomAnchor, constant: 8),
            humidityLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            humidityLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            windLabel.topAnchor.constraint(equalTo: humidityLabel.bottomAnchor, constant: 8),
            windLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            windLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            windLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20)
        ])
    }
}
