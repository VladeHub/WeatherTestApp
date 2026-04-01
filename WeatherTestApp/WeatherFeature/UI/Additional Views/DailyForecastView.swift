//
//  DailyForecastView.swift
//  WeatherTestApp
//

import UIKit

final class DailyForecastView: UIView {
    
    // MARK: - UI Elements
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Прогноз на 3 дня"
        label.font = .systemFont(ofSize: 24, weight: .semibold)
        return label
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.distribution = .fillEqually
        return stackView
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
    func configure(with forecast: ForecastResponse) {
        // Очищаем старые данные
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        // Добавляем каждый день прогноза
        for day in forecast.forecast.forecastday {
            let dayView = ForecastDayView(day: day)
            stackView.addArrangedSubview(dayView)
        }
    }
}

private extension DailyForecastView {
    // MARK: - Setup
    func setupUI() {
        addSubview(titleLabel)
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            stackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
