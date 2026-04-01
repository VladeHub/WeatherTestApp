//
//  HourlyWeatherCell.swift
//  WeatherTestApp
//

import UIKit

final class HourlyWeatherCell: UICollectionViewCell {
    
    // MARK: - UI Elements
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray6
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        return view
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let temperatureLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    
    private let conditionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 12)
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        label.numberOfLines = 2
        label.lineBreakMode = .byWordWrapping   
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        iconImageView.image = nil
        timeLabel.text = nil
        temperatureLabel.text = nil
        conditionLabel.text = nil
    }
    
    // MARK: - Configuration
    func configure(with hour: ForecastResponse.Hour) {
        timeLabel.text = DataFormatter.shared.formatHour(hour.time)
        temperatureLabel.text = String(format: "%.1f°", hour.tempC)
        conditionLabel.text = hour.condition.text
        
        if let iconURL = URL(string: "https:\(hour.condition.icon)") {
            ImageLoader.shared.loadImage(into: iconImageView,
                                         from: iconURL,
                                         placeholder: UIImage(systemName: "cloud"))
        }
    }
}
 
private extension HourlyWeatherCell {
    // MARK: - Setup
    func setupUI() {
        contentView.addSubview(containerView)
        
        containerView.addSubview(timeLabel)
        containerView.addSubview(iconImageView)
        containerView.addSubview(temperatureLabel)
        containerView.addSubview(conditionLabel)
        
        setupConstraints()
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            // Container View - заполняет всю ячейку с небольшими отступами
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 2),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 2),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -2),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -2),
            
            // Time Label
            timeLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            timeLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 4),
            timeLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -4),
            
            // Icon Image View
            iconImageView.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 8),
            iconImageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 44),
            iconImageView.heightAnchor.constraint(equalToConstant: 44),
            
            // Temperature Label
            temperatureLabel.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: 6),
            temperatureLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 4),
            temperatureLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -4),
            
            // Condition Label
            conditionLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 6),
            conditionLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -6),
            conditionLabel.bottomAnchor.constraint(lessThanOrEqualTo: containerView.bottomAnchor, constant: -13)
        ])
    }
}
