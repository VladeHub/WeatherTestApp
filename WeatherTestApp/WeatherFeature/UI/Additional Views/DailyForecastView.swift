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
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.isScrollEnabled = false
        tableView.allowsSelection = false
        tableView.register(ForecastDayCell.self, forCellReuseIdentifier: "ForecastDayCell")
        return tableView
    }()
    
    // MARK: - Properties
    private var forecastDays: [ForecastResponse.ForecastDay] = []
    private var tableViewHeightConstraint: NSLayoutConstraint?
    
    // MARK: - Consts
    private let rowHeight: CGFloat = 104
    private let spacing: CGFloat = 8
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupTableView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func setupUI() {
        addSubview(titleLabel)
        addSubview(tableView)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    // MARK: - Configuration
    func configure(with forecast: ForecastResponse) {
        forecastDays = forecast.forecast.forecastday
        tableView.reloadData()
        updateTableViewHeight()
    }
    
    private func updateTableViewHeight() {
        let numberOfRows = forecastDays.count
        let totalHeight = CGFloat(numberOfRows) * rowHeight + CGFloat(numberOfRows - 1) * spacing
        
        tableViewHeightConstraint?.isActive = false
        tableViewHeightConstraint = tableView.heightAnchor.constraint(equalToConstant: totalHeight)
        tableViewHeightConstraint?.isActive = true
        tableView.isScrollEnabled = false
        tableView.invalidateIntrinsicContentSize()
    }
}

// MARK: - UITableViewDataSource
extension DailyForecastView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forecastDays.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ForecastDayCell", for: indexPath) as! ForecastDayCell
        let day = forecastDays[indexPath.row]
        cell.configure(with: day)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension DailyForecastView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return rowHeight
    }
}
