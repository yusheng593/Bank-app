//
//  AccountSummaryViewController.swift
//  Bankey
//
//  Created by yusheng Lu on 2024/8/21.
//

import UIKit

class AccountSummaryViewController: UIViewController {
    // Request Models
    var profile: Profile?
    var accounts: [Account] = []
    // View Models
    var headerViewModel = AccountSummaryHeaderView.ViewModel(welcomeMessage: "Welcome", name: "", date: Date())
    var accountCellViewModels: [AccountSummaryCell.ViewModel] = []

    private let tableView = UITableView()
    private let headerView = AccountSummaryHeaderView(frame: .zero)
    private let refreshControl = UIRefreshControl()

    // Networking
    var profileManager: ProfileManageable = ProfileManager()

    // Error alert
    lazy var errorAlert: UIAlertController = {
        let alert =  UIAlertController(title: "", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        return alert
    }()

    private var isLoaded = false

    private lazy var logoutBarButtonItem: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logoutTapped))
        barButtonItem.tintColor = .label
        return barButtonItem
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
}

extension AccountSummaryViewController {
    private func setup() {
        setupTableView()
        setupTableHeaderView()
        setupNavigationBar()
        fetchData()
        setupRefreshControl()
        setupSkeletons()
    }

    private func setupTableView() {
        tableView.backgroundColor = Colors.appColor
        tableView.delegate = self
        tableView.dataSource = self

        tableView.register(AccountSummaryCell.self, forCellReuseIdentifier: AccountSummaryCell.reuseID)
        tableView.register(SkeletonCell.self, forCellReuseIdentifier: SkeletonCell.reuseID)

        tableView.rowHeight = AccountSummaryCell.rowHeight
        tableView.tableFooterView = UIView()

        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    private func setupTableHeaderView() {
        var size = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        size.width = UIScreen.main.bounds.width
        headerView.frame.size = size

        tableView.tableHeaderView = headerView
    }

    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = logoutBarButtonItem
    }

    private func setupRefreshControl() {
        refreshControl.tintColor = Colors.appColor
        refreshControl.addTarget(self, action: #selector(refreshContent), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }

    private func setupSkeletons() {
        let row = Account.makeSkeleton()
        accounts = Array(repeating: row, count: 10)

        configureTableCells(with: accounts)
    }
}
// MARK: Actions
extension AccountSummaryViewController {
    @objc func logoutTapped(sender: UIButton) {
        NotificationCenter.default.post(name: .logout, object: nil)
    }

    @objc func refreshContent() {
        reset()
        setupSkeletons()
        tableView.reloadData()
        fetchData()
    }

    private func reset() {
        profile = nil
        accounts = []
        isLoaded = false
    }
}

extension AccountSummaryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard !accountCellViewModels.isEmpty else { return UITableViewCell() }
        let account = accountCellViewModels[indexPath.row]

        if isLoaded {
            let cell = tableView.dequeueReusableCell(withIdentifier: AccountSummaryCell.reuseID, for: indexPath) as! AccountSummaryCell
            cell.configure(with: account)
            return cell
        }

        let cell = tableView.dequeueReusableCell(withIdentifier: SkeletonCell.reuseID, for: indexPath) as! SkeletonCell
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accountCellViewModels.count
    }
}

extension AccountSummaryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
}

// MARK: - Networking
extension AccountSummaryViewController {

    private func fetchData() {
        // 測試用
        let userId = String(Int.random(in: 1..<4))

        Task {
            do {
                self.profile = try await  profileManager.fetchProfile(forUserId: userId)
                self.accounts = try await fetchAccounts(forUserId: userId)
                self.reloadView()
            } catch {
                self.displayError(NetworkError.serverError)
            }
        }

    }

    @MainActor
    private func reloadView() {
        self.tableView.refreshControl?.endRefreshing()

        guard let profile = self.profile else { return }

        self.isLoaded = true
        self.configureTableHeaderView(with: profile)
        self.configureTableCells(with: self.accounts)
        self.tableView.reloadData()
    }

    private func configureTableHeaderView(with profile: Profile) {
        let vm = AccountSummaryHeaderView.ViewModel(welcomeMessage: "Good morning,",
                                                    name: profile.firstName,
                                                    date: Date())
        headerView.configure(viewModel: vm)
    }

    private func configureTableCells(with accounts: [Account]) {
        accountCellViewModels = accounts.map {
            AccountSummaryCell.ViewModel(accountType: $0.type,
                                         accountName: $0.name,
                                         balance: $0.amount)
        }
    }

    private func displayError(_ error: NetworkError) {
        let titleAndMessage = titleAndMessage(for: error)
        self.showErrorAlert(title: titleAndMessage.0, message: titleAndMessage.1)
    }

    private func titleAndMessage(for error: NetworkError) -> (String, String) {
        let title: String
        let message: String
        switch error {
        case .serverError:
            title = "Server Error"
            message = "We could not process your request. Please try again."
        case .decodingError:
            title = "Network Error"
            message = "Ensure you are connected to the internet. Please try again."
        case .invalidURLError:
            title = "Invalid URL"
            message = "Please check your URL and try again."
        }
        return (title, message)
    }

    private func showErrorAlert(title: String, message: String) {
        errorAlert.title = title
        errorAlert.message = message

        present(errorAlert, animated: true, completion: nil)
    }
}
// MARK: Unit testing
extension AccountSummaryViewController {
    func titleAndMessageForTesting(for error: NetworkError) -> (String, String) {
        return titleAndMessage(for: error)
    }

    func forceFetchProfile() {
        Task {
            do {
                self.profile =  try await profileManager.fetchProfile(forUserId: "1")
            } catch {
                // 錯誤處理
                print("Error: \(error)")
            }
        }
    }

    func forceFetchAccount() {
        Task {
            do {
                self.accounts =  try await fetchAccounts(forUserId: "1")
            } catch {
                // 錯誤處理
                print("Error: \(error)")
            }
        }
    }
}
