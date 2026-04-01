//
//  WeatherViewController.swift
//  WeatherTestApp
//

import UIKit
internal import Combine

final class WeatherViewController: UIViewController {
    
    // MARK: - UI Elements
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let loadingView = LoadingView()
    private let errorView = ErrorView()
    private let currentWeatherView = CurrentWeatherView()
    private let hourlyForecastView = HourlyForecastView()
    private let dailyForecastView = DailyForecastView()
    
    private var contentViews: [UIView] {
        return [currentWeatherView, hourlyForecastView, dailyForecastView]
    }
    
    // MARK: - Properties
    private let viewModel = WeatherViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
        setupActions()
        
        Task {
            await viewModel.loadWeather()
        }
    }
}

// MARK: - Private Methods
private extension WeatherViewController {
    
    // MARK: - Setup UI
    func setupUI() {
        title = "Погода"
        view.backgroundColor = .systemBackground
        
        // Добавляем scrollView
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        // Добавляем компоненты
        [loadingView, errorView, currentWeatherView, hourlyForecastView, dailyForecastView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        
        setupConstraints()
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            // ScrollView
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // ContentView
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            // LoadingView
            loadingView.topAnchor.constraint(equalTo: contentView.topAnchor),
            loadingView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            loadingView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            loadingView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            // ErrorView
            errorView.topAnchor.constraint(equalTo: contentView.topAnchor),
            errorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            errorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            errorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            // CurrentWeatherView
            currentWeatherView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            currentWeatherView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            currentWeatherView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // HourlyForecastView
            hourlyForecastView.topAnchor.constraint(equalTo: currentWeatherView.bottomAnchor, constant: 24),
            hourlyForecastView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            hourlyForecastView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            // DailyForecastView
            dailyForecastView.topAnchor.constraint(equalTo: hourlyForecastView.bottomAnchor, constant: 24),
            dailyForecastView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            dailyForecastView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            dailyForecastView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }
    
    // MARK: - Setup Bindings
    func setupBindings() {
        viewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                if isLoading {
                    self?.loadingView.startLoading()
                    self?.setContentVisible(false)
                } else {
                    self?.loadingView.stopLoading()
                }
            }
            .store(in: &cancellables)
        
        viewModel.$errorMessage
            .receive(on: DispatchQueue.main)
            .sink { [weak self] errorMessage in
                if let error = errorMessage {
                    self?.errorView.showError(error)
                    self?.setContentVisible(false)
                } else {
                    self?.errorView.hide()
                }
            }
            .store(in: &cancellables)
        
        viewModel.$currentWeather
            .receive(on: DispatchQueue.main)
            .sink { [weak self] weather in
                if let weather = weather {
                    self?.currentWeatherView.configure(with: weather)
                    self?.currentWeatherView.isHidden = false
                }
            }
            .store(in: &cancellables)
        
        viewModel.$forecast
            .receive(on: DispatchQueue.main)
            .sink { [weak self] forecast in
                if let forecast = forecast {
                    self?.hourlyForecastView.configure(with: forecast)
                    self?.dailyForecastView.configure(with: forecast)
                    self?.setContentVisible(true)
                }
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Setup Actions
    func setupActions() {
        errorView.onRetry = { [weak self] in
            Task {
                await self?.viewModel.loadWeather()
            }
        }
    }
    
    // MARK: - Helper Methods
    func setContentVisible(_ visible: Bool) {
        contentViews.forEach { $0.isHidden = !visible }
    }
}
