//
//  LoadingView.swift
//  WeatherTestApp
//

import UIKit

final class LoadingView: UIView {
    
    private let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func startLoading() {
        loadingIndicator.startAnimating()
        isHidden = false
    }
    
    func stopLoading() {
        loadingIndicator.stopAnimating()
        isHidden = true
    }
}

private extension LoadingView {
    func setupUI() {
        addSubview(loadingIndicator)
        
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -100)
        ])
    }
}
