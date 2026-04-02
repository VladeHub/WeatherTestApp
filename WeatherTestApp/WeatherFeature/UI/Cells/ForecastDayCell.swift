//
//  ForecastDayCell.swift
//  WeatherTestApp
//

import UIKit

final class ForecastDayCell: UITableViewCell {
    
    // MARK: - UI Elements
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray6
        view.layer.cornerRadius = 16
        return view
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18, weight: .semibold)
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
        label.font = .systemFont(ofSize: 22, weight: .bold)
        return label
    }()
    
    private let conditionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 15)
        label.textColor = .secondaryLabel
        label.textAlignment = .right
        return label
    }()
    
    private let minMaxLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 13)
        label.textColor = .secondaryLabel
        label.textAlignment = .right
        return label
    }()
    
    // MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        iconImageView.image = nil
        dateLabel.text = nil
        tempLabel.text = nil
        conditionLabel.text = nil
        minMaxLabel.text = nil
    }
    
    // MARK: - Setup
    private func setupUI() {
        backgroundColor = .clear
        selectionStyle = .none
        
        contentView.addSubview(containerView)
        containerView.addSubview(dateLabel)
        containerView.addSubview(iconImageView)
        containerView.addSubview(tempLabel)
        containerView.addSubview(conditionLabel)
        containerView.addSubview(minMaxLabel)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Container View
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            // Date Label
            dateLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            dateLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            
            // Icon Image View
            iconImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            iconImageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -8),
            iconImageView.widthAnchor.constraint(equalToConstant: 44),
            iconImageView.heightAnchor.constraint(equalToConstant: 44),
            
            // Temperature Label
            tempLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 20),
            tempLabel.centerYAnchor.constraint(equalTo: iconImageView.centerYAnchor),
            
            // Condition Label
            conditionLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            conditionLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            
            // Min/Max Label
            minMaxLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            minMaxLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16)
        ])
    }
    
    
    // MARK: - Configuration
    func configure(with day: ForecastResponse.ForecastDay) {
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
