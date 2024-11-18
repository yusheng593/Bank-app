//
//  UITextField+SecureToggle.swift
//  Bankey
//
//  Created by yusheng Lu on 2024/8/26.
//

import UIKit

extension UITextField {
    func enablePasswordToggle() {
        let passwordToggleButton = UIButton(type: .custom)
        passwordToggleButton.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        passwordToggleButton.setImage(UIImage(systemName: "eye"), for: .selected)
        passwordToggleButton.addTarget(self, action: #selector(togglePassword), for: .touchUpInside)
        rightView = passwordToggleButton
        rightViewMode = .always
    }

    @objc func togglePassword() {
        isSecureTextEntry.toggle()
        if let button = rightView as? UIButton {
            button.isSelected.toggle()
        }
    }
}
