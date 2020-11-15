//
//  LoginViewController.swift
//  ChatTogether
//
//  Created by Trần Sơn on 11/8/20.
//

import UIKit
import SnapKit

class SignInViewController: UIViewController {
//    setup entities
    private let loginText:UITextView = {
        let welText = UITextView()
        welText.text = "LOGIN"
        welText.textAlignment = .center
        welText.font = UIFont(name: "Geeza Pro", size: 18)
        welText.textColor = .black
        welText.backgroundColor = .none
        return welText
    }()
    
    private let questionLabel:UILabel = {
        let label = UILabel()
        label.text = "Don't have an Account?"
        label.textAlignment = .center
        label.textColor = UIColor(red: 95/255, green: 78/255, blue: 128/255, alpha: 1)
        label.font = UIFont(name: "Geeza Pro", size: 16)
        return label
    }()
    
    private let loginButton:UIButton = {
        
        let button = UIButton()
        button.setTitle("LOG IN", for: .normal)
        button.backgroundColor = UIColor(red: 98/255, green: 58/255, blue: 154/255, alpha: 0.9)
        button.layer.cornerRadius = 30
        button.setTitleColor(.white, for: .normal)
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        
        return button
        
    }()
    
    private let signUpButton:UIButton = {
        
        let button = UIButton()
        button.setTitle("Sign Up", for: .normal)
        button.setTitleColor(UIColor(red: 98/255, green: 58/255, blue: 154/255, alpha: 0.9), for: .normal)
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
        return button

    }()
    
    private let imageBackground:UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "login")
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
        imageView.image = imageView.image?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = UIColor(red: 98/255, green: 58/255, blue: 154/255, alpha: 0.9)
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
        let imageView = UIImageView(image: UIImage(named: "icon_pass"))
        imageView.image = imageView.image?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = UIColor(red: 98/255, green: 58/255, blue: 154/255, alpha: 0.9)
        field.leftView = imageView
        field.leftViewMode = .always
        
        field.backgroundColor = UIColor(red: 239/255, green: 232/255, blue: 253/255, alpha: 1)
        field.isSecureTextEntry = true
        return field
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
//  add subview to superView
        view.addSubview(imageBackground)
        view.addSubview(imageDecorTop)
        view.addSubview(imageDecorBottom)
        view.addSubview(loginText)
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(loginButton)
        view.addSubview(questionLabel)
        view.addSubview(signUpButton)
        
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        signUpButton.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        self.hideKeyboardWhenTappedAround()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        emailTextField.becomeFirstResponder()
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
        

        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.snp.makeConstraints { (make) ->Void in
            make.top.greaterThanOrEqualTo(passwordTextField.snp.bottom).offset(20)
            make.leading.equalTo(self.view).offset(55)
            make.trailing.equalTo(self.view).offset(-55)
            make.height.equalTo(60)
        }


        loginText.snp.makeConstraints { (make) ->Void in
            make.top.greaterThanOrEqualTo(imageBackground.snp.top).offset(-40)
            make.size.equalTo(CGSize(width: 300, height: 50))
            make.leading.equalTo(self.view).offset(40)
            make.trailing.equalTo(self.view).offset(-40)
        }

        questionLabel.snp.makeConstraints { (make) ->Void in
            make.top.equalTo(loginButton.snp.bottom).offset(20)
            
            make.centerX.equalTo(self.view.snp.centerX).offset(-40)
            //make.trailing.equalTo(self.view).offset(-40)
        }
        signUpButton.snp.makeConstraints { (make) ->Void in
            make.top.equalTo(loginButton.snp.bottom).offset(10)
            make.leading.equalTo(questionLabel.snp.trailing).offset(5)
        }
        
    }
    
    @objc private func loginButtonTapped()
    {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        
        guard let email = emailTextField.text,let pass = passwordTextField.text,!email.isEmpty, !pass.isEmpty else {
            alertUserLoginError()
            return
        }
    }
    
    @objc private func signUpButtonTapped()
    {
        let vc = SignUpViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func alertUserLoginError() {
            let alert = UIAlertController(title: "Woops",
                                          message: "Please enter all information to log in.",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title:"Dismiss",
                                          style: .cancel, handler: nil))
            present(alert, animated: true)
        }
    
}

extension SignInViewController:UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField
        {
            passwordTextField.becomeFirstResponder()
        }
        else if textField == passwordTextField
        {
            loginButtonTapped()
        }
        return true
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SignInViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

