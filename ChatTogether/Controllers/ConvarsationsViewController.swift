//
//  ViewController.swift
//  ChatTogether
//
//  Created by Trần Sơn on 11/7/20.
//

import UIKit
import FirebaseAuth
import JGProgressHUD

class ConvarsationsViewController: UIViewController {
    
    private let spinner = JGProgressHUD(style: .dark)
    
    private let tableView:UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.isHidden = true
        return tableView
    }()
    
    private let noConvarsationsLabel:UILabel = {
        let label = UILabel()
        label.text = "No Convarsations!!"
        label.textAlignment = .center
        label.textColor = .gray
        label.font = .systemFont(ofSize: 21, weight: .medium)
        label.isHidden = true
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(didTapComposeButton))
        
        view.addSubview(tableView)
        view.addSubview(noConvarsationsLabel)
        setupTableView()
        fetchConvarsations()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        validateAuth()
    }
    
    private func validateAuth()
    {
        if FirebaseAuth.Auth.auth().currentUser == nil {
            let vc = WelcomeViewController()
            let nav = UINavigationController(rootViewController: vc)
            nav.modalPresentationStyle = .fullScreen
            nav.isNavigationBarHidden = true
            present(nav, animated: true, completion: nil)
            
        }
    }
    
    private func setupTableView()
    {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func fetchConvarsations()
    {
        tableView.isHidden = false
    }
    
    // choose New Convarsation
    @objc func didTapComposeButton()
    {
        let newConvar = NewConversationViewController()
        
        let navController = UINavigationController(rootViewController: newConvar)
        
        present(navController, animated: true, completion: nil)
    }

}

extension ConvarsationsViewController: UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "Hello"
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let vc = ChatViewController()
        vc.title = "John Smith"
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

