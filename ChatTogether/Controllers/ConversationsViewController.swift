//
//  ViewController.swift
//  ChatTogether
//
//  Created by Trần Sơn on 11/7/20.
//

import UIKit
import FirebaseAuth
import JGProgressHUD

class ConversationsViewController: UIViewController {
    
    private let spinner = JGProgressHUD(style: .dark)
    
    private var conversations = [Conversation]()
    
    private let tableView:UITableView = {
        let tableView = UITableView()
        tableView.register(ConversationTableViewCell.self, forCellReuseIdentifier: ConversationTableViewCell.identifier)
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
        startListeningForConversations()
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
    
    private func startListeningForConversations(){
        
        guard let email = UserDefaults.standard.value(forKey: "email") as? String else {
            return
        }
        print("starting conversation fetch...")
        
        let safeEmail = DatabaseManager.safeEmail(emailAddress: email)
        
        DatabaseManager.shared.getAllConversations(for: safeEmail, completion: {[weak self] result in
            switch result {
            case .success(let conversations):
                print("successfully got conversation models")
                guard !conversations.isEmpty else {
//                    self?.tableView.isHidden = true
//                    self?.noConversationsLabel.isHidden = false
                    return
                }
//                self?.noConversationsLabel.isHidden = true
//                self?.tableView.isHidden = false
                self?.conversations = conversations
              
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            case .failure(let error):
//                self?.tableView.isHidden = true
//                self?.noConversationsLabel.isHidden = false
                print("failed to get convos: \(error)")
            }
        })
    }
    
    // choose New Convarsation
    @objc func didTapComposeButton()
    {
        let newConvar = NewConversationViewController()
        newConvar.completion = { [weak self] result in
//            guard let strongSelf = self else {
//                return
//            }
            print("\(result)")
            self?.createNewConVersation(result: result)
        }
        
        let navController = UINavigationController(rootViewController: newConvar)
        
        present(navController, animated: true, completion: nil)
    }
    private func createNewConVersation(result : [String:String]){
        guard let email = result["emailAddress"], let name = result["userName"] else {
            return
        }
        let vc = ChatViewController(with: email,id: nil)
        vc.isNewConversation = true
        vc.title = name
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }

}

extension ConversationsViewController: UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conversations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = conversations[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: ConversationTableViewCell.identifier, for: indexPath) as! ConversationTableViewCell
        cell.configure(with: model)

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = conversations[indexPath.row]
        
        let vc = ChatViewController(with: model.otherUserEmail,id: model.id)
        vc.title = model.name
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}

