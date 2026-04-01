//
//  ForecastDayView.swift
//  WeatherTestApp
//

import UIKit

final class ForecastDayView: UIView {
    
    // MARK: - UI Elements
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let tempLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18, weight: .bold)
        return label
    }()
    
    private let conditionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14)
        label.textColor = .secondaryLabel
        label.textAlignment = .right
        return label
    }()
    
    private let minMaxLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 12)
        label.textColor = .secondaryLabel
        label.textAlignment = .right
        return label
    }()
    
    // MARK: - Properties
    private let day: ForecastResponse.ForecastDay
    
    // MARK: - Initialization
    init(day: ForecastResponse.ForecastDay) {
        self.day = day
        super.init(frame: .zero)
        setupUI()
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension ForecastDayView {
    // MARK: - Setup
    func setupUI() {
        backgroundColor = .systemGray6
        layer.cornerRadius = 12
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(dateLabel)
        addSubview(iconImageView)
        addSubview(tempLabel)
        addSubview(conditionLabel)
        addSubview(minMaxLabel)
        
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 80),
            
            dateLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            dateLabel.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            
            iconImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            iconImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
            iconImageView.widthAnchor.constraint(equalToConstant: 30),
            iconImageView.heightAnchor.constraint(equalToConstant: 30),
            
            tempLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 12),
            tempLabel.centerYAnchor.constraint(equalTo: iconImageView.centerYAnchor),
            
            conditionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            conditionLabel.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            
            minMaxLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            minMaxLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12)
        ])
    }
    
    func configure() {
        dateLabel.text = DataFormatter.shared.formatDate(day.date)
        tempLabel.text = String(format: "%.1f°C", day.day.avgtempC)
        conditionLabel.text = day.day.condition.text
        minMaxLabel.text = "Среднее: \(day.day.avgtempC, default: "%.1f")° | макс: \(day.day.avgtempC, default: "%.1f")°"
        
        if let iconURL = URL(string: "https:\(day.day.condition.icon)") {
            ImageLoader.shared.loadImage(into: iconImageView,
                                         from: iconURL,
                                         placeholder: UIImage(systemName: "cloud.fill"))
        }
    }
}
