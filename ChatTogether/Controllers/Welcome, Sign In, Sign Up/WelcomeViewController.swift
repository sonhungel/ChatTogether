//
//  WelcomeViewController.swift
//  ChatTogether
//
//  Created by Trần Sơn on 11/12/20.
//

import UIKit
import SnapKit

class WelcomeViewController: UIViewController {
    
//    setup entities
    private let welcomeText:UITextView = {
        let welText = UITextView()
        welText.text = "WELCOME TO CHATTOGETHER"
        welText.textAlignment = .center
        welText.font = UIFont(name: "Geeza Pro", size: 18)
        welText.textColor = .black
        welText.backgroundColor = .none
        return welText
    }()
    
    @objc private let loginButton:UIButton = {
        let button = UIButton()
        button.setTitle("LOG IN", for: .normal)
        //button.backgroundColor = .purple
        button.backgroundColor = UIColor(red: 98/255, green: 58/255, blue: 154/255, alpha: 0.9)
        button.layer.cornerRadius = 26
        button.setTitleColor(.white, for: .normal)
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        
        return button
        
    }()
    private let imageBackground:UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "welcome")
        return imageView
    }()
    
    private let imageDecorTop:UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "main_top")
        return imageView
    }()
    
    private let imageDecorBottom:UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "main_bottom")
        return imageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)

        view.backgroundColor = .white
        view.addSubview(imageBackground)
        view.addSubview(welcomeText)
        view.addSubview(imageDecorTop)
        view.addSubview(imageDecorBottom)
        view.addSubview(loginButton)
    }
//    autolayout
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    
        imageBackground.snp.makeConstraints { (make) ->Void in
            //make.edges.equalTo(self.view).inset(UIEdgeInsets(top: 120, left: 40, bottom: 250, right: 40))
            make.center.equalTo(view)
        }

        imageDecorTop.snp.makeConstraints { (make) ->Void in
            make.top.equalTo(view)
            make.leading.equalTo(view)
            make.trailing.equalTo(view).offset(-200)
            make.bottom.lessThanOrEqualTo(imageBackground.snp.top)
        }
        
        imageDecorBottom.snp.makeConstraints { (make) ->Void in
            make.top.greaterThanOrEqualTo(imageBackground.snp.bottom).offset(50)
            make.leading.equalTo(view)
            make.trailing.equalTo(view).offset(-300)
            make.bottom.equalTo(view)
        }

        loginButton.snp.makeConstraints { (make) ->Void in
            make.top.greaterThanOrEqualTo(imageBackground.snp.bottom).offset(25)
            make.leading.equalTo(view).offset(80)
            make.trailing.equalTo(view).offset(-80)
            make.bottom.lessThanOrEqualTo(view.snp.bottom).offset(-100)
            make.height.equalTo(55)
        }
        
        welcomeText.snp.makeConstraints { (make) ->Void in
            make.top.greaterThanOrEqualTo(imageBackground.snp.top).offset(-40)
            make.size.equalTo(CGSize(width: 300, height: 50))
            make.leading.equalTo(view).offset(40)
            make.trailing.equalTo(view).offset(-40)
        }
        
    }
    
    @objc private func loginButtonTapped()
    {
        let vc = SignInViewController()
        navigationController?.pushViewController(vc, animated: true)
    }

}
