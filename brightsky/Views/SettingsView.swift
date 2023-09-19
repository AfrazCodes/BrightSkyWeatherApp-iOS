//
//  SettingsView.swift
//  brightsky
//
//  Created by Afraz Siddiqui on 9/18/23.
//

import UIKit

protocol SettingsViewDelegate: AnyObject {
    func settingsView(_ settingsView: SettingsView, didTap option: SettingOption)
}

final class SettingsView: UIView, UITableViewDelegate, UITableViewDataSource {

    weak var delegate: SettingsViewDelegate?

    private var viewModel: SettingsViewViewModel? {
        didSet {
            tableView.reloadData()
        }
    }

    private let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.rightAnchor.constraint(equalTo: rightAnchor),
            tableView.leftAnchor.constraint(equalTo: leftAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    public func configure(with viewModel: SettingsViewViewModel) {
        self.viewModel = viewModel
    }

    // MARK: - Table

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.options.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if let viewModel {
            cell.textLabel?.text = viewModel.options[indexPath.row].title
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        guard let viewModel else { return }
        let option = viewModel.options[indexPath.row]
        // Handle tap
        delegate?.settingsView(self, didTap: option)
    }
}
