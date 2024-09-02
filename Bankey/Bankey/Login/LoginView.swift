//
//  LoginView.swift
//  Bankey
//
//  Created by yusheng Lu on 2024/2/27.
//

import UIKit

class LoginView: UIView {
    enum TextFieldTag: Int {
        case username = 0
        case password = 1
    }

    lazy var usernameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = Strings.username
        textField.delegate = self
        textField.tag = TextFieldTag.username.rawValue
        textField.snp.makeConstraints { make in
            make.height.equalTo(48)
        }
        textField.text = "Samuel"
        return textField
    }()

    lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = Strings.password
        textField.isSecureTextEntry = true
        textField.delegate = self
        textField.tag = TextFieldTag.password.rawValue
        textField.snp.makeConstraints { make in
            make.height.equalTo(48)
        }
        textField.text = "isawesome"
        textField.enablePasswordToggle()
        return textField
    }()

    private lazy var dividerView: UIView = {
        let view = UIView()
        view.backgroundColor = .secondarySystemFill
        return view
    }()

    private lazy var stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 8
        view.addArrangedSubview(usernameTextField)
        view.addArrangedSubview(dividerView)
        view.addArrangedSubview(passwordTextField)
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        style()
        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension LoginView {

    func style() {
        backgroundColor = .secondarySystemBackground
        layer.cornerRadius = 5
        clipsToBounds = true
    }

    func layout() {
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.leading.equalToSuperview().offset(8)
            make.trailing.equalToSuperview().offset(-8)
            make.bottom.equalToSuperview().offset(-8)
        }

        dividerView.snp.makeConstraints { make in
            make.height.equalTo(1)
        }
    }
}

extension LoginView: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        usernameTextField.endEditing(true)
        passwordTextField.endEditing(true)
        return true
    }

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
    }
}
