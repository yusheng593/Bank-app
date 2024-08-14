//
//  OnboardingViewController.swift
//  Bankey
//
//  Created by yusheng Lu on 2024/8/14.
//

import UIKit

class OnboardingViewController: UIViewController {

    let stackView = UIStackView()
    let imageView = UIImageView()
    let imageName = "delorean"
    let label = UILabel()
    let labelText = "Bankey is faster, easier to use, and has a brand new look and feel that will make you feel like you are back in the 80s."

    override func viewDidLoad() {
        super.viewDidLoad()
        style()
        layout()
    }
}

extension OnboardingViewController {
    func style() {
        view.backgroundColor = .systemBackground

        stackView.axis = .vertical
        stackView.spacing = 20

        // Image
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: imageName)

        // Label
        label.textAlignment = .center
        label.font = UIFont.preferredFont(forTextStyle: .title3)
        label.adjustsFontForContentSizeCategory = true
        label.numberOfLines = 0
        label.text = labelText
    }

    func layout() {
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(label)

        view.addSubview(stackView)

        stackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.equalToSuperview().offset(8)
            make.trailing.equalToSuperview().offset(-8)
        }
    }
}
