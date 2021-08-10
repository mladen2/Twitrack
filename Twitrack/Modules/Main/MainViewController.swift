//
//  MainViewController.swift
//  Twitrack
//
//  Created by Mladen Nisevic on 10/08/2021.
//  
//

import UIKit

class MainViewController: UIViewController {

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

    // MARK: - Properties
    var presenter: ViewToPresenterMainProtocol?

    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter?.viewDidLoad()
    }
}

extension MainViewController: PresenterToViewMainProtocol {

    func onDataRefresh() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    func onError(error: String) {
        let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        DispatchQueue.main.async {
            self.present(alert, animated: true) {
            }
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
        let ret = presenter?.tweets?.count ?? 0
        pr("there are : \(ret) tweets")
        return ret
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

// MARK: -
// MARK: Init
// MARK: -
extension MainViewController {

    func setupUI() {
        navigationItem.title = "Twitrack"
        view.backgroundColor = UIColor.systemBackground

    }
}
