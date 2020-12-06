//
//  ProfileViewController.swift
//  ChatTogether
//
//  Created by Trần Sơn on 11/8/20.
//

import UIKit
import SnapKit
import FirebaseAuth
import FBSDKLoginKit
import GoogleSignIn
import SDWebImage

class ProfileViewController: UIViewController {
   
    private let tableView:UITableView = {
        let tableView = UITableView()
        return tableView
    }()
    
    var data = [ProfileViewModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(ProfileTableViewCell.self, forCellReuseIdentifier: ProfileTableViewCell.identifier)
        
        data.append(ProfileViewModel(viewModelType: .info,
                                     title: "Name: \(UserDefaults.standard.value(forKey:"name") as? String ?? "No Name")",
                                     handler: nil))
        data.append(ProfileViewModel(viewModelType: .info,
                                     title: "Email: \(UserDefaults.standard.value(forKey:"email") as? String ?? "No Email")",
                                     handler: nil))
        
        data.append(ProfileViewModel(viewModelType: .logout, title: "Log Out", handler: { [weak self] in
            
            guard let strongSelf = self else {
                            return
                        }
            let actionSheet = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
            
            actionSheet.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: { [weak self] _ in
                guard let strongSelf = self else {
                    return
                }
                
                UserDefaults.standard.setValue(nil, forKey: "email")
                UserDefaults.standard.setValue(nil, forKey: "name")
//                UserDefaults.standard.removeObject(forKey: "email")
//                UserDefaults.standard.removeObject(forKey: "name")
                
//                let email = UserDefaults.standard.value(forKey:"email") as? String
//                let name = UserDefaults.standard.value(forKey:"name") as? String
//                print("Email: \(email ?? "Deo co email nua"), ten : \(name ?? "Deo co ten nua")")
//
//                strongSelf.tabBarController?.dismiss(animated: true, completion: nil)
//                strongSelf.navigationController?.dismiss(animated: true, completion: nil)
                
                // Log Out Facebook
                FBSDKLoginKit.LoginManager().logOut()
                // Google Sign Out
                GIDSignIn.sharedInstance()?.signOut()
                
                do {
                    try FirebaseAuth.Auth.auth().signOut()
                    let vc = WelcomeViewController()
                    let nav = UINavigationController(rootViewController: vc)
                    nav.modalPresentationStyle = .fullScreen
                    nav.isNavigationBarHidden = true
                    strongSelf.present(nav, animated: true, completion: nil)
                }
                catch{
                    print("Failed to Log Out")
                }
                
            }))
            actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
            strongSelf.present(actionSheet, animated: true, completion: nil)
           
        }))
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.tableHeaderView = createTableHeader()
        view.addSubview(tableView)
    }
    override func viewDidLayoutSubviews() {
        tableView.snp.makeConstraints({ (make) ->Void in
            make.top.equalTo(view)
            make.leading.equalTo(view)
            make.trailing.equalTo(view)
            make.bottom.equalTo(view)
        })
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.tableHeaderView = createTableHeader()
        reload()
    }
    
    func createTableHeader() -> UIView? {
        guard  let email = UserDefaults.standard.value(forKey: "email") as? String else {
            return nil
        }
        let safeEmail = DatabaseManager.safeEmail(emailAddress: email)
        let filename = safeEmail + "_profile_picture.png"
        let path = "images/"+filename
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width , height: 300))
        headerView.backgroundColor = .link
        
        let imageView = UIImageView(frame: CGRect(x: (headerView.frame.width-150) / 2,
                                                          y: 75,
                                                          width: 150,
                                                          height: 150))
        
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .white
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.borderWidth = 3
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = imageView.frame.width/2
        
        headerView.addSubview(imageView)
        
        StorageManager.shared.downloadURL(for: path, completion: {result in
            switch result {
            case .success(let url ):
                imageView.sd_setImage(with: url, completed: nil)
            case .failure(let error):
                print("Failed to get download url: \(error)")
            }
        })
        
        return headerView
    }
    
    public func reload()
    {
        tableView.tableHeaderView = createTableHeader()
        
        data.removeAll()
        
        data.append(ProfileViewModel(viewModelType: .info,
                                     title: "Name: \(UserDefaults.standard.value(forKey:"name") as? String ?? "No Name")",
                                     handler: nil))
        data.append(ProfileViewModel(viewModelType: .info,
                                     title: "Email: \(UserDefaults.standard.value(forKey:"email") as? String ?? "No Email")",
                                     handler: nil))
        
        data.append(ProfileViewModel(viewModelType: .logout, title: "Log Out", handler: { [weak self] in
            
            guard let strongSelf = self else {
                            return
                        }
            let actionSheet = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
            
            actionSheet.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: { [weak self] _ in
                guard let strongSelf = self else {
                    return
                }
                
//                UserDefaults.standard.setValue(nil, forKey: "email")
//                UserDefaults.standard.setValue(nil, forKey: "name")
                UserDefaults.standard.removeObject(forKey: "email")
                UserDefaults.standard.removeObject(forKey: "name")
                
//                let email = UserDefaults.standard.value(forKey:"email") as? String
//                let name = UserDefaults.standard.value(forKey:"name") as? String
//                print("Email: \(email ?? "Deo co email nua"), ten : \(name ?? "Deo co ten nua")")

                strongSelf.tabBarController?.dismiss(animated: true, completion: nil)
                strongSelf.navigationController?.dismiss(animated: true, completion: nil)
                
                // Log Out Facebook
                FBSDKLoginKit.LoginManager().logOut()
                // Google Sign Out
                GIDSignIn.sharedInstance()?.signOut()
                
                do {
                    try FirebaseAuth.Auth.auth().signOut()
                    let vc = WelcomeViewController()
                    let nav = UINavigationController(rootViewController: vc)
                    nav.modalPresentationStyle = .fullScreen
                    nav.isNavigationBarHidden = true
                    strongSelf.present(nav, animated: true, completion: nil)
                }
                catch{
                    print("Failed to Log Out")
                }
                
            }))
            actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
            strongSelf.present(actionSheet, animated: true, completion: nil)
           
        }))
        tableView.reloadData()
    }

}

extension ProfileViewController : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let viewModel = data[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: ProfileTableViewCell.identifier,for: indexPath) as! ProfileTableViewCell
        cell.setUp(with: viewModel)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        data[indexPath.row].handler?()
    }
    
}

class ProfileTableViewCell: UITableViewCell {

    static let identifier = "ProfileTableViewCell"

    public func setUp(with viewModel: ProfileViewModel) {
        textLabel?.text = viewModel.title
        switch viewModel.viewModelType {
        case .info:
            textLabel?.textAlignment = .left
            selectionStyle = .none
        case .logout:
            textLabel?.textColor = .red
            textLabel?.textAlignment = .center
        }
    }

}
