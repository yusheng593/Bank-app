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
    let heroImageName: String
    let label = UILabel()
    let titleText: String

    init(heroImageName: String, titleText: String) {
        self.heroImageName = heroImageName
        self.titleText = titleText

        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        imageView.image = UIImage(named: heroImageName)

        // Label
        label.textAlignment = .center
        label.font = UIFont.preferredFont(forTextStyle: .title3)
        label.adjustsFontForContentSizeCategory = true
        label.numberOfLines = 0
        label.text = titleText
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
