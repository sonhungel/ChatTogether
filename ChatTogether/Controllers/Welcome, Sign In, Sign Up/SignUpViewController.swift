//
//  RegisterViewController.swift
//  ChatTogether
//
//  Created by Trần Sơn on 11/8/20.
//

import UIKit
import SnapKit

class SignUpViewController: UIViewController {
    //    setup entities
        private let signUpText:UITextView = {
            let welText = UITextView()
            welText.text = "SIGNUP"
            welText.textAlignment = .center
            welText.font = UIFont(name: "Geeza Pro", size: 18)
            welText.textColor = .black
            welText.backgroundColor = .none
            return welText
        }()
        
        private let signUpButton:UIButton = {
            
            let button = UIButton()
            button.setTitle("SIGN UP", for: .normal)
            button.backgroundColor = UIColor(red: 98/255, green: 58/255, blue: 154/255, alpha: 0.9)
            button.layer.cornerRadius = 30
            button.setTitleColor(.white, for: .normal)
            button.layer.masksToBounds = true
            button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
            
            return button
            
        }()
        private let imageBackground:UIImageView = {
            let imageView = UIImageView()
            imageView.image = UIImage(named: "signup")
    //        imageView.backgroundColor = .black
            return imageView
        }()
        
        private let imageDecorTop:UIImageView = {
            let imageView = UIImageView()
            imageView.image = UIImage(named: "main_top")
            
            return imageView
        }()
        
        private let imageDecorBottom:UIImageView = {
            let imageView = UIImageView()
            imageView.image = UIImage(named: "login_bottom")
            return imageView
        }()
        
        private let emailTextField:UITextField = {
            let field = UITextField()
            field.autocapitalizationType = .none
            field.autocorrectionType = .no
            field.returnKeyType = .continue
            field.layer.cornerRadius = 30
            field.placeholder = "Your Email"
            let imageView = UIImageView(image: UIImage(named: "icon_email"))
            imageView.frame = CGRect(x: 0, y: 0, width: 50, height: 0)
            field.leftView = imageView
            
            field.leftViewMode = .always
            field.backgroundColor = UIColor(red: 239/255, green: 232/255, blue: 253/255, alpha: 1)
            return field

        }()
        
        private let passwordTextField:UITextField = {
            let field = UITextField()
            field.autocapitalizationType = .none
            field.autocorrectionType = .no
            field.returnKeyType = .done
            field.layer.cornerRadius = 30
     
            field.placeholder = "Your Password"
            field.leftView = UIImageView(image: UIImage(named: "icon_pass"))
            let buttonShowPass = UIButton()
            buttonShowPass.setImage(UIImage(named: "icon_eye"), for: .normal)
            field.rightView = buttonShowPass
            field.leftViewMode = .always
            field.rightViewMode = .always
            field.backgroundColor = UIColor(red: 239/255, green: 232/255, blue: 253/255, alpha: 1)
            field.isSecureTextEntry = true
            return field
        }()

        override func viewDidLoad() {
            super.viewDidLoad()

            view.addSubview(imageBackground)
            view.addSubview(imageDecorTop)
            view.addSubview(imageDecorBottom)
            view.addSubview(signUpText)
            view.addSubview(emailTextField)
            view.addSubview(passwordTextField)
            view.addSubview(signUpButton)
        }
        
    //    autolayout
        override func viewDidLayoutSubviews() {
            super.viewDidLayoutSubviews()

            imageBackground.snp.makeConstraints { (make) ->Void in
                
                make.top.greaterThanOrEqualTo(self.view).offset(100)
                make.leading.equalTo(self.view).offset(25)
                make.trailing.equalTo(self.view).offset(-25)
            }

            imageDecorTop.snp.makeConstraints { (make) ->Void in
                make.top.equalTo(self.view)
                make.leading.equalTo(self.view)
                make.size.equalTo(CGSize(width: 150, height: 170))
                
            }

            imageDecorBottom.snp.makeConstraints { (make) ->Void in
                make.size.equalTo(CGSize(width: 170, height: 150))
                make.trailing.equalTo(self.view)
                make.bottom.equalTo(self.view)
            }

            emailTextField.snp.makeConstraints { (make) ->Void in
                make.top.greaterThanOrEqualTo(imageBackground.snp.bottom).offset(10)
                make.height.equalTo(60)
                make.leading.equalTo(self.view).offset(55)
                make.trailing.equalTo(self.view).offset(-55)
            }
            passwordTextField.snp.makeConstraints { (make) ->Void in
                make.top.greaterThanOrEqualTo(emailTextField.snp.bottom).offset(10)
                make.height.equalTo(60)
                make.leading.equalTo(self.view).offset(55)
                make.trailing.equalTo(self.view).offset(-55)
            }
            

            signUpButton.translatesAutoresizingMaskIntoConstraints = false
            signUpButton.snp.makeConstraints { (make) ->Void in
                make.top.greaterThanOrEqualTo(passwordTextField.snp.bottom).offset(20)
                make.leading.equalTo(self.view).offset(55)
                make.trailing.equalTo(self.view).offset(-55)
                //make.bottom.lessThanOrEqualTo(self.view.snp.bottom).offset(-100)
                make.height.equalTo(60)
            }


            signUpText.snp.makeConstraints { (make) ->Void in
                make.top.greaterThanOrEqualTo(imageBackground.snp.top).offset(-40)
                make.size.equalTo(CGSize(width: 300, height: 50))
                make.leading.equalTo(self.view).offset(40)
                make.trailing.equalTo(self.view).offset(-40)
            }
            
        }
        
}
