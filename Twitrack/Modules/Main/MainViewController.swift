//
//  MainViewController.swift
//  Twitrack
//
//  Created by Mladen Nisevic on 10/08/2021.
//  
//

import UIKit
import AuthenticationServices

extension String {
    static var empty = ""
}

private extension String {
    static var twitrack = "Twitrack"
    static var pause = "Pause"
    static var error = "Error"
    static var ok = "OK"
}

final class MainViewController: UIViewController {

    lazy var tableView: UITableView = {
        var tableView = UITableView()
        tableView.register(MainTableViewCell.self, forCellReuseIdentifier: MainTableViewCell.cellID)

        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableView.automaticDimension

        tableView.dataSource = self
        tableView.delegate = self

        tableView.tableFooterView = UIView()

        return tableView
    }()

    lazy var infoLabel: UILabel = {
        var label = UILabel.label(.footnote, text: .empty, textColour: UIColor.secondaryLabel)
        return label
    }()

    // MARK: - Properties
    var presenter: ViewToPresenterMainProtocol?

    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter?.viewDidLoad()
    }

    @objc
    func toggleStreaming() {
        presenter?.toggleStreaming()
    }
}

extension MainViewController: PresenterToViewMainProtocol {

    func onDataRefresh() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

    func onError(error: String) {
        let alert = UIAlertController(title: .error, message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: .ok, style: .default))
        DispatchQueue.main.async {
            self.present(alert, animated: true) {
            }
        }
    }

    func showMessage(_ message: String) {
        DispatchQueue.main.async {
            self.infoLabel.text = message
        }
    }
}

extension MainViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        presenter?.didSelect(indexPath.row)
    }
}

extension MainViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter?.interactor?.tweets.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MainTableViewCell.cellID, for: indexPath) as! MainTableViewCell
        if presenter?.hasTweet(for: indexPath.row) == true {
            cell.userNameLabel.text = presenter?.name(for: indexPath.row)
            cell.screenNameLabel.text = presenter?.screenName(for: indexPath.row)
            cell.avatarImageView.image = presenter?.avatar(for: indexPath.row)
            cell.statusLabel.attributedText = presenter?.status(for: indexPath.row)
            cell.infoLabel.text = presenter?.timeCreated(for: indexPath.row)
        }
        return cell
    }
}

extension MainViewController: ASWebAuthenticationPresentationContextProviding {
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        self.view.window!
    }
}

// MARK: Init
extension MainViewController {

    func setupUI() {
        navigationItem.title = .twitrack
        view.backgroundColor = UIColor.systemBackground

        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        let guide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: guide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: guide.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: guide.trailingAnchor),
            tableView.leadingAnchor.constraint(equalTo: guide.leadingAnchor)
        ])

        view.addSubview(infoLabel)
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            infoLabel.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -4),
            infoLabel.bottomAnchor.constraint(equalTo: guide.bottomAnchor, constant: -4)
        ])

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: .pause, style: UIBarButtonItem.Style.plain, target: self, action: #selector(toggleStreaming))
    }
}
