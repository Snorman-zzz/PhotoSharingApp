//
//  SettingsViewController.swift
//  A-List
//
//  Created by Norman Yuan on 11/14/21.
//  Copyright © 2021 A-List. All rights reserved.
//

import SafariServices
import UIKit

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(UITableViewCell.self,
                       forCellReuseIdentifier: "cell")
        return table
    }()
    
    private var sections: [SettingsSection] = []
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "设置"
        view.addSubview(tableView)
        configureModels()
        tableView.delegate = self
        tableView.dataSource = self
        view.backgroundColor = .systemBackground
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .close,
            target: self,
            action: #selector(didTapClose))
        createTableFooter()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    @objc func didTapClose() {
        dismiss(animated: true, completion: nil)
    }
    
    private func configureModels() {
        sections.append(
            SettingsSection(title: "应用", options: [
                SettingOption(
                    title: "评价应用",
                    image: UIImage(systemName: "star"),
                    color: .systemOrange
                ) {
                    guard let url = URL(string: "https://apps.apple.com")
                    else {
                        return
                    }
                    DispatchQueue.main.async {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }
                },
                    SettingOption(
                        title: "分享应用",
                        image: UIImage(systemName: "square.and.arrow.up"),
                        color: .systemBlue
                    ) { [weak self] in
                        guard let url = URL(string: "https://apps.apple.com")
                        else {
                            return
                        }
                        DispatchQueue.main.async {
                            let vc = UIActivityViewController(activityItems: [url], applicationActivities: [])
                            self?.present(vc, animated: true)
                        }
                    }
            ])
        )
        
        sections.append(
            SettingsSection(title: "信息", options: [
                SettingOption(
                    title: "使用条款",
                    image: UIImage(systemName: "doc"),
                    color: .systemPink
                ) { [weak self] in
                    DispatchQueue.main.async {
                        guard let url = URL(string: "https://apple.com")
                        else {
                            return
                        }
                        let vc = SFSafariViewController(url: url)
                        self?.present(vc, animated: true, completion: nil)
                    }
                },
                    SettingOption(
                        title: "数据使用政策",
                        image: UIImage(systemName: "hand.raised"),
                        color: .systemGreen
                    ) { [weak self] in
                        guard let url = URL(string: "https://apple.com")
                        else {
                            return
                        }
                        let vc = SFSafariViewController(url: url)
                        self?.present(vc, animated: true, completion: nil)
                    },
                SettingOption(
                    title: "帮助",
                    image: UIImage(systemName: "message"),
                    color: .systemPurple
                ) { [weak self] in
                    guard let url = URL(string: "https://apple.com")
                    else {
                        return
                    }
                    let vc = SFSafariViewController(url: url)
                    self?.present(vc, animated: true, completion: nil)
                }
            ])
        )
    }
    
    // Table
    
    private func createTableFooter() {
        let footer = UIView(frame: CGRect(x: 0, y: 0, width: view.width, height: 50))
        footer.clipsToBounds = true
        
        let button = UIButton(frame: footer.bounds)
        footer.addSubview(button)
        button.setTitle("退出",
                        for: .normal)
        
        button.setTitleColor(.systemRed, for: .normal)
        button.addTarget(self, action: #selector(didTapSignOut), for: .touchUpInside)
        
        tableView.tableFooterView = footer
    }
    
    @objc func didTapSignOut() {
        let actionSheet = UIAlertController(
            title: "退出",
            message: "推出后不会删除任何历史数据，下次登录依然可以使用本账号。",
            preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        actionSheet.addAction(UIAlertAction(title: "退出登录", style: .destructive, handler: { [weak self] _ in
            AuthManager.shared.signOut { success in
                if success {
                    DispatchQueue.main.async {
                            let vc = SignInViewController()
                            let navVC = UINavigationController(rootViewController: vc)
                            navVC.modalPresentationStyle = .fullScreen
                        self?.present(navVC, animated: true)
                    }
                }
            }
        }))
        present(actionSheet, animated: true)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].options.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = sections[indexPath.section].options[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = model.title
        cell.imageView?.image = model.image
        cell.imageView?.tintColor = model.color
        cell.accessoryType = .disclosureIndicator
        return cell
        }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = sections[indexPath.section].options[indexPath.row]
        model.handler()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].title
    }
}
