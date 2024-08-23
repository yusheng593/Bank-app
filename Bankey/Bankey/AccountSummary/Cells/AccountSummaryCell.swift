//
//  AccountSummaryCell.swift
//  Bankey
//
//  Created by yusheng Lu on 2024/8/23.
//

import UIKit

class AccountSummaryCell: UITableViewCell {
    enum AccountType: String {
        case Banking
        case CreditCard
        case Investment
    }

    struct ViewModel {
        let accountType: AccountType
        let accountName: String
    }

    let viewModel: ViewModel? = nil

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
        label.attributedText = makeFormattedBalance(dollars: "929,466", cents: "23")
        return label
    }()

    private lazy var chevronImageView: UIImageView = {
        let imageView = UIImageView()
        let chevronImage = UIImage(systemName: "chevron.right")!.withTintColor(appColor, renderingMode: .alwaysOriginal)
        imageView.image = chevronImage
        return imageView
    }()

    static let reuseID = "AccountSummaryCell"
    static let rowHeight: CGFloat = 112

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

    private func makeFormattedBalance(dollars: String, cents: String) -> NSMutableAttributedString {
        let dollarSignAttributes: [NSAttributedString.Key: Any] = [.font: UIFont.preferredFont(forTextStyle: .callout), .baselineOffset: 8]
        let dollarAttributes: [NSAttributedString.Key: Any] = [.font: UIFont.preferredFont(forTextStyle: .title1)]
        let centAttributes: [NSAttributedString.Key: Any] = [.font: UIFont.preferredFont(forTextStyle: .footnote), .baselineOffset: 8]

        let rootString = NSMutableAttributedString(string: "$", attributes: dollarSignAttributes)
        let dollarString = NSAttributedString(string: dollars, attributes: dollarAttributes)
        let centString = NSAttributedString(string: cents, attributes: centAttributes)

        rootString.append(dollarString)
        rootString.append(centString)

        return rootString
    }
}

extension AccountSummaryCell {
    func configure(with vm: ViewModel) {

        typeLabel.text = vm.accountType.rawValue
        nameLabel.text = vm.accountName

        switch vm.accountType {
        case .Banking:
            underlineView.backgroundColor = appColor
            balanceLabel.text = "Current balance"
        case .CreditCard:
            underlineView.backgroundColor = .systemOrange
            balanceLabel.text = "Current balance"
        case .Investment:
            underlineView.backgroundColor = .systemPurple
            balanceLabel.text = "Value"
        }
    }
}
