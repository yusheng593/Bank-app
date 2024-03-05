//
//  ViewController.swift
//  Bankey
//
//  Created by yusheng Lu on 2024/2/27.
//

import UIKit
import SnapKit

class LoginViewController: UIViewController {

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        label.textAlignment = .center
        label.numberOfLines = 1
        label.textColor = .label
        label.text = "Bankey"
        return label
    }()

    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: UIFont.systemFontSize, weight: .medium)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .label
        label.text = "Your premium source for all things banking!"
        return label
    }()

    private var username: String? {
        return loginView.usernameTextField.text
    }

    private var password: String? {
        return loginView.passwordTextField.text
    }

    private let loginView = LoginView()

    private lazy var signInButton: UIButton = {
        let button = UIButton(type: .system)
        button.configuration = .filled()
        button.configuration?.imagePadding = 8
        button.setTitle("Login", for: .normal)
        button.addTarget(self, action: #selector(signInTapped), for: .primaryActionTriggered)
        return button
    }()

    private lazy var errorMessageLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .systemRed
        label.isHidden = true
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        style()
        layout()
    }
}

extension LoginViewController {
    private func style() {
        view.backgroundColor = .systemBackground
    }

    private func layout() {
        view.addSubview(loginView)
        loginView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(8)
            make.trailing.equalToSuperview().offset(-8)
        }

        view.addSubview(signInButton)
        signInButton.snp.makeConstraints { make in
            make.top.equalTo(loginView.snp.bottom).offset(16)
            make.leading.trailing.equalTo(loginView)
            make.height.equalTo(48)
        }

        view.addSubview(errorMessageLabel)
        errorMessageLabel.snp.makeConstraints { make in
            make.top.equalTo(signInButton.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
        }

        view.addSubview(subtitleLabel)
        subtitleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(loginView.snp.top).offset(-16)
            make.leading.trailing.equalTo(loginView)
        }

        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(subtitleLabel.snp.top).offset(-16)
        }


    }
    
}
//MARK: - Actions
extension LoginViewController {
    @objc private func signInTapped() {
        errorMessageLabel.isHidden = true
        login()
    }

    private func login() {
        guard let username = username, let password = password else { assertionFailure("Username / password should never be nil")
            return }

        if username.isEmpty || password.isEmpty {
            configureView(withMessage: "Username / Password cannot be blank")
            return
        }

        if username == "Samuel" && password == "isawesome" {
            signInButton.configuration?.showsActivityIndicator = true
        } else {
            configureView(withMessage: "Incorrect username / password")
        }
    }

    private func configureView(withMessage message: String) {
        errorMessageLabel.isHidden = false
        errorMessageLabel.text = message
    }
}
