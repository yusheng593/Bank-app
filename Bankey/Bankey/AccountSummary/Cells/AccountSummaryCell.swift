//
//  AccountSummaryCell.swift
//  Bankey
//
//  Created by yusheng Lu on 2024/8/23.
//

import UIKit

class AccountSummaryCell: UITableViewCell {
    lazy var typeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        label.adjustsFontForContentSizeCategory = true
        label.text = "Account type"
        return label
    }()

    let underlineView = UIView()

    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.adjustsFontForContentSizeCategory = true
        label.text = "Account name"
        return label
    }()

    private lazy var balanceStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 0
        return stackView
    }()

    lazy var balanceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.textAlignment = .right
        label.text = "Some balance"
        return label
    }()

    lazy var balanceAmountLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.text = "$929,466.63"
        return label
    }()

    private lazy var chevronImageView: UIImageView = {
        let imageView = UIImageView()
        let chevronImage = UIImage(systemName: "chevron.right")!.withTintColor(appColor, renderingMode: .alwaysOriginal)
        imageView.image = chevronImage
        return imageView
    }()

    static let reuseID = "AccountSummaryCell"
    static let rowHeight: CGFloat = 100

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension AccountSummaryCell {
    private func setup() {
        underlineView.backgroundColor = appColor

        contentView.addSubview(typeLabel) // imporant! Add to contentView.
        contentView.addSubview(underlineView)
        contentView.addSubview(nameLabel)

        balanceStackView.addArrangedSubview(balanceLabel)
        balanceStackView.addArrangedSubview(balanceAmountLabel)

        contentView.addSubview(balanceStackView)
        contentView.addSubview(chevronImageView)
    }

    private func layout() {
        typeLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(16)
        }

        underlineView.snp.makeConstraints { make in
            make.top.equalTo(typeLabel.snp.bottom).offset(8)
            make.leading.equalTo(typeLabel.snp.leading)
            make.width.equalTo(60)
            make.height.equalTo(4)
        }

        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(underlineView.snp.bottom).offset(16)
            make.leading.equalTo(typeLabel.snp.leading)
        }

        balanceStackView.snp.makeConstraints { make in
            make.top.equalTo(underlineView.snp.bottom)
            make.leading.equalTo(nameLabel.snp.trailing).offset(4)
            make.trailing.equalToSuperview().inset(32)
        }

        chevronImageView.snp.makeConstraints { make in
            make.top.equalTo(underlineView.snp.bottom).offset(8)
            make.trailing.equalToSuperview().inset(8)
        }
    }
}
