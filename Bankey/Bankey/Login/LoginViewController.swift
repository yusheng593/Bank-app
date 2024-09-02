//
//  ViewController.swift
//  Bankey
//
//  Created by yusheng Lu on 2024/2/27.
//

import UIKit
import SnapKit

protocol LogoutDelegate: AnyObject {
    func didLogout()
}

protocol LoginViewControllerDelegate: AnyObject {
    func didLogin()
}

class LoginViewController: UIViewController {

    weak var delegate: LoginViewControllerDelegate?

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        label.textAlignment = .center
        label.numberOfLines = 1
        label.textColor = .label
        label.text = Strings.bankey
        label.alpha = 0
        return label
    }()

    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: UIFont.systemFontSize, weight: .medium)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .label
        label.text = Strings.loginViewSubtitle
        label.alpha = 0
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
        button.setTitle(Strings.loginViewButtonTitle, for: .normal)
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

    // animation
    var leadingEdgeOffScreen: CGFloat = -1000

    override func viewDidLoad() {
        super.viewDidLoad()

        style()
        layout()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animate()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        signInButton.configuration?.showsActivityIndicator = false
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
            make.bottom.equalTo(loginView.snp.top).offset(-16)
            make.leading.trailing.equalTo(leadingEdgeOffScreen)
        }

        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.bottom.equalTo(subtitleLabel.snp.top).offset(-16)
            make.leading.equalTo(view.snp.leading).offset(leadingEdgeOffScreen)
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
            delegate?.didLogin()
        } else {
            configureView(withMessage: "Incorrect username / password")
        }
    }

    private func configureView(withMessage message: String) {
        errorMessageLabel.isHidden = false
        errorMessageLabel.text = message
        shakeButton()
    }
}

// MARK: - Animations
extension LoginViewController {
    private func animate() {
        let duration = 0.8

        let animator1 = UIViewPropertyAnimator(duration: duration, curve: .easeInOut) {
            self.titleLabel.snp.remakeConstraints { make in
                make.bottom.equalTo(self.subtitleLabel.snp.top).offset(-16)
                make.trailing.equalTo(self.loginView.snp.trailing)
                make.centerX.equalToSuperview()
            }
            self.view.layoutIfNeeded()
        }
        animator1.startAnimation()

        let animator2 = UIViewPropertyAnimator(duration: duration, curve: .easeInOut) {
            self.subtitleLabel.snp.remakeConstraints { make in
                make.bottom.equalTo(self.loginView.snp.top).offset(-16)
                make.leading.trailing.equalTo(self.loginView)
                make.centerX.equalToSuperview()
            }
            self.view.layoutIfNeeded()
        }
        animator2.startAnimation(afterDelay: 0.2)

        let animator3 = UIViewPropertyAnimator(duration: duration * 2, curve: .easeInOut) {
            self.titleLabel.alpha = 1
            self.subtitleLabel.alpha = 1
            self.view.layoutIfNeeded()
        }
        animator3.startAnimation(afterDelay: 0.2)
    }

    private func shakeButton() {
        let animation = CAKeyframeAnimation()
        animation.keyPath = "position.x"
        animation.values = [0, 10, -10, 10, 0]
        animation.keyTimes = [0, 0.16, 0.5, 0.83, 1]
        animation.duration = 0.4

        animation.isAdditive = true
        signInButton.layer.add(animation, forKey: "shake")
    }
}
