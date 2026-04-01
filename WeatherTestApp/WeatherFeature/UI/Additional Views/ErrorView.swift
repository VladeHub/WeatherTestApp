//
//  ErrorView.swift
//  WeatherTestApp
//

import UIKit

final class ErrorView: UIView {
    
    // MARK: - UI Elements
    private let errorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .systemRed
        label.isHidden = true
        return label
    }()
    
    private let retryButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Повторить", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.isHidden = true
        return button
    }()
    
    // MARK: - Properties
    var onRetry: (() -> Void)?
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    func showError(_ message: String) {
        errorLabel.text = message
        errorLabel.isHidden = false
        retryButton.isHidden = false
    }
    
    func hide() {
        errorLabel.isHidden = true
        retryButton.isHidden = true
    }
}

private extension ErrorView {
    // MARK: - Setup
    func setupUI() {
        addSubview(errorLabel)
        addSubview(retryButton)
        
        NSLayoutConstraint.activate([
            errorLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            errorLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -50),
            errorLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            errorLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            retryButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            retryButton.topAnchor.constraint(equalTo: errorLabel.bottomAnchor, constant: 20),
            retryButton.widthAnchor.constraint(equalToConstant: 120),
            retryButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    func setupActions() {
        retryButton.addTarget(self, action: #selector(retryButtonTapped), for: .touchUpInside)
    }
    
    @objc func retryButtonTapped() {
        onRetry?()
    }
}
