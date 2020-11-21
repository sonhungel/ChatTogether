//
//  ViewController.swift
//  ChatTogether
//
//  Created by Trần Sơn on 11/7/20.
//

import UIKit
import FirebaseAuth

class ConvarsationsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        let isLoggedIn = UserDefaults.standard.bool(forKey: "logged_in")
//        
//        if !isLoggedIn{
//            let vc = WelcomeViewController()
//            let nav = UINavigationController(rootViewController: vc)
//            nav.modalPresentationStyle = .fullScreen
//            nav.isNavigationBarHidden = true
//            present(nav, animated: true, completion: nil)
//            
//        }
        
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


}

