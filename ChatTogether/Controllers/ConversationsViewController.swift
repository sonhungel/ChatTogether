//
//  ViewController.swift
//  ChatTogether
//
//  Created by Trần Sơn on 11/7/20.
//

import UIKit
import FirebaseAuth
import JGProgressHUD
import SnapKit

class ConversationsViewController: UIViewController {
    
    
    private let spinner = JGProgressHUD(style: .dark)
    
    private var conversations = [Conversation]()
    
    public let tableView:UITableView = {
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
    
    private var loginObserver:NSObjectProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .secondarySystemBackground
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(didTapComposeButton))
        
        view.addSubview(tableView)
        view.addSubview(noConvarsationsLabel)
        setupTableView()
        startListeningForConversations()
        
        loginObserver = NotificationCenter.default.addObserver(forName: Notification.Name.didLogInNotification , object: nil, queue: .main, using: { [weak self]_ in

            guard let strongSelf = self else {
                return
            }

            strongSelf.startListeningForConversations()
        })
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
        noConvarsationsLabel.frame = CGRect(x: 10,
                                            y: (view.frame.height-100)/2,
                                            width: view.frame.width-20,
                                            height: 100)
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //reload()
        startListeningForConversations()
    }
    
    
    private func setupTableView()
    {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func startListeningForConversations(){
        
        guard let email = UserDefaults.standard.value(forKey: "email") as? String else {
            return
        }
        
        if let observer = loginObserver {
            NotificationCenter.default.removeObserver(observer)
        }
        
        print("starting conversation fetch...")
        
        let safeEmail = DatabaseManager.safeEmail(emailAddress: email)
        
        DatabaseManager.shared.getAllConversations(for: safeEmail, completion: {[weak self] result in
            switch result {
            case .success(let conversations):
                print("successfully got conversation models")
                guard !conversations.isEmpty else {
                    self?.tableView.isHidden = true
                    self?.noConvarsationsLabel.isHidden = false
                    return
                }
                self?.noConvarsationsLabel.isHidden = true
                self?.tableView.isHidden = false
                self?.conversations = conversations
              
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                self?.tableView.isHidden = true
                self?.noConvarsationsLabel.isHidden = false
                print("failed to get convos: \(error)")
            }
        })
    }
    
    public func reload(){
        self.conversations.removeAll()
        startListeningForConversations()
        tableView.reloadData()
    }
    
    // choose New Convarsation
    @objc func didTapComposeButton()
    {
        let newConvar = NewConversationViewController()
        newConvar.completion = { [weak self] result in
            guard let strongSelf = self else {
                return
            }
            
            let currentConversations = strongSelf.conversations
            
            if let targetConversation = currentConversations.first(where: {
                $0.otherUserEmail == DatabaseManager.safeEmail(emailAddress: result.emailAddress)
            }) {
                let vc = ChatViewController(with: targetConversation.otherUserEmail, id: targetConversation.id)
                vc.isNewConversation = false
                vc.title = targetConversation.name
                vc.navigationItem.largeTitleDisplayMode = .never
                strongSelf.navigationController?.pushViewController(vc, animated: true)
            }
            else {
                print("\(result)")
                strongSelf.createNewConversation(result: result)
            }
        }
        
        let navController = UINavigationController(rootViewController: newConvar)
        present(navController, animated: true, completion: nil)
    }
    private func createNewConversation(result : SearchResult){
        let email = result.emailAddress
        let name = result.userName
        
        // check in datbase if conversation with these two users exists
        // if it does, reuse conversation id
        // otherwise use existing code
        
        DatabaseManager.shared.conversationExists(iwth: email, completion: {[weak self] result in
            guard let strongSelf = self else {
                return
            }
            switch result {
            case .success(let conversationId):
                let vc = ChatViewController(with: email, id: conversationId)
                vc.isNewConversation = false
                vc.title = name
                vc.navigationItem.largeTitleDisplayMode = .never
                strongSelf.navigationController?.pushViewController(vc, animated: true)
            case .failure(_):
                let vc = ChatViewController(with: email, id: nil)
                vc.isNewConversation = true
                vc.title = name
                vc.navigationItem.largeTitleDisplayMode = .never
                strongSelf.navigationController?.pushViewController(vc, animated: true)
            }
        })
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
        
        openConversation(model)
    }
    
    func openConversation(_ model: Conversation) {
        let vc = ChatViewController(with: model.otherUserEmail, id: model.id)
        vc.title = model.name
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            // begin delete
            let conversationId = conversations[indexPath.row].id
            tableView.beginUpdates()
            self.conversations.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .left)
            
            DatabaseManager.shared.deleteConversation(conversationId: conversationId, completion: { success in
                if !success {
                    // add model and row back and show error alert
                }
            })
            
            tableView.endUpdates()
        }
    }
    

}

