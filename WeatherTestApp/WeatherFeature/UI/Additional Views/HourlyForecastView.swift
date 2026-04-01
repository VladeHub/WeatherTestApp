//
//  HourlyForecastView.swift
//  WeatherTestApp
//

import UIKit

final class HourlyForecastView: UIView {
    
    // MARK: - UI Elements
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Почасовой прогноз"
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        return label
    }()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 12
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.alwaysBounceVertical = false
        collectionView.isScrollEnabled = true
        collectionView.register(HourlyWeatherCell.self, forCellWithReuseIdentifier: "HourlyWeatherCell")
        return collectionView
    }()
    
    // MARK: - Properties
    private var hourlyForecast: [ForecastResponse.Hour] = []
    private let cellHeight: CGFloat = 160
    private let cellWidth: CGFloat = 94
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configuration
    func configure(with forecast: ForecastResponse) {
        hourlyForecast = forecast.forecast.forecastday.first?.hour ?? []
        collectionView.reloadData()
    }
}

// MARK: - UICollectionView DataSource & Delegate
extension HourlyForecastView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return hourlyForecast.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HourlyWeatherCell", for: indexPath) as! HourlyWeatherCell
        let hour = hourlyForecast[indexPath.item]
        cell.configure(with: hour)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cellWidth, height: cellHeight - 4) // Немного меньше высоты контейнера
    }
}

private extension HourlyForecastView {
    // MARK: - Setup
    func setupUI() {
        addSubview(titleLabel)
        addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            collectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: cellHeight)
        ])
    }
    
    func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
    }
}
