//
//  LoginViewController.swift
//  ChatTogether
//
//  Created by Trần Sơn on 11/8/20.
//

import UIKit
import SnapKit
import FirebaseAuth
import FBSDKLoginKit
import GoogleSignIn

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
//        let imageView = UIImageView(image: UIImage(named: "icon_email"))
//        imageView.image = imageView.image?.withRenderingMode(.alwaysTemplate)
//        imageView.tintColor = UIColor(red: 98/255, green: 58/255, blue: 154/255, alpha: 0.9)
//        field.leftView = imageView
        
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
//        let imageView = UIImageView(image: UIImage(named: "icon_pass"))
//        imageView.image = imageView.image?.withRenderingMode(.alwaysTemplate)
//        imageView.tintColor = UIColor(red: 98/255, green: 58/255, blue: 154/255, alpha: 0.9)
//        field.leftView = imageView
        field.leftViewMode = .always
        
        field.backgroundColor = UIColor(red: 239/255, green: 232/255, blue: 253/255, alpha: 1)
        field.isSecureTextEntry = true
        return field
    }()
    
    private let imageEmail:UIView = {
        let view = UIView()
        view.frame.size = CGSize(width: 40, height: 20)
        let imageView = UIImageView(image: UIImage(named: "icon_email"))
        imageView.image = imageView.image?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = UIColor(red: 98/255, green: 58/255, blue: 154/255, alpha: 0.9)
       
        //imageView.backgroundColor = .black
        imageView.center = view.center
        view.addSubview(imageView)
        return view
    }()
    
    private let imagePass:UIView = {
        let view = UIView()
        view.frame.size = CGSize(width: 40, height: 20)
        //view.backgroundColor = .black
        let imageView = UIImageView(image: UIImage(named: "icon_pass"))
        imageView.image = imageView.image?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = UIColor(red: 98/255, green: 58/255, blue: 154/255, alpha: 0.9)
       
        //imageView.backgroundColor = .black
        imageView.center = view.center
        view.addSubview(imageView)
        
        return view
    }()
    
    private let faceBookLoginButton: FBLoginButton = {
        let button = FBLoginButton()
        button.permissions = ["public_profile", "email"]
        
        // normal
        button.setTitleColor(.clear, for: .normal)
        button.setImage(UIImage(named: "facebook"), for: .normal)

        //button.setBackgroundImage(nil, for: .normal)
        
//        // tapped
//        button.setTitleColor(.clear, for: .highlighted)
//        button.setImage(nil, for: .highlighted)
//        button.setBackgroundImage(nil, for: .highlighted)
        return button
    }()
    
    private let googleLoginButton:GIDSignInButton = {
        let button = GIDSignInButton()
        return button
    }()
    
    private var loginObserve: NSObjectProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        
        loginObserve = NotificationCenter.default.addObserver(forName: Notification.Name.didLogInNotification , object: nil, queue: .main, using: { [weak self]_ in
          
            guard let strongSelf = self else {
                return
            }
            
            strongSelf.navigationController?.dismiss(animated: true, completion: nil )
        })
        
        GIDSignIn.sharedInstance()?.presentingViewController = self
        
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
        view.addSubview(faceBookLoginButton)
        view.addSubview(googleLoginButton)
        
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        signUpButton.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        faceBookLoginButton.delegate = self
        
        
        emailTextField.leftView = imageEmail
        passwordTextField.leftView = imagePass
        
        self.hideKeyboardWhenTappedAround()
    

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        emailTextField.becomeFirstResponder()
    }
    
    deinit {
        if let observe = loginObserve {
            NotificationCenter.default.removeObserver(observe)
        }
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
        
        faceBookLoginButton.snp.makeConstraints { (make) ->Void in
            make.top.equalTo(questionLabel.snp.bottom)
            //make.bottom.equalTo(self.view)
        }
        googleLoginButton.snp.makeConstraints { (make) ->Void in
            make.top.equalTo(faceBookLoginButton.snp.bottom)
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
        
        // firebase sign in
        
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: pass) { [weak self ]authResult, error in
            
            guard let strongSelf = self else {
                return
            }
            guard let result = authResult, error == nil else {
                print("Failed to login user with email :\(email)")
                return
            }
            
            let user = result.user
            print("Logged In user :\(user)")
            
            strongSelf.navigationController?.dismiss(animated: true, completion: nil)
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

extension SignInViewController :LoginButtonDelegate{
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        /// no operation
    }
    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        guard let token = result?.token?.tokenString else {
            print("User failed to log in with Facebook")
            return
        }
        
        let facebookRequest = FBSDKLoginKit.GraphRequest(graphPath: "me", parameters: ["fields":"email,name"], tokenString: token, version: nil, httpMethod: .get)
        
        facebookRequest.start(completionHandler: { connection, result, error in
            guard let result = result as? [String:Any], error == nil else
            {
                print("Failed to make facebook graph request")
                return
            }
            print("\(result)")
            
            
            guard let userName = result["name"]  as? String,
                  let email = result["email"] as? String else {
                print("Faield to get email and name from fb result")
                return
            }
            
            DatabaseManager.shared.userExists(with: email, completion: { exists in
                if !exists {
                    DatabaseManager.shared.insertUser(with: ChatTogetherAppUser(userName: userName, emailAdress: email))
                }
            })
            
            let credential = FacebookAuthProvider.credential(withAccessToken: token)
            FirebaseAuth.Auth.auth().signIn(with: credential, completion: { [weak self]authResult, error in
                guard let strongSelf = self else {
                    return
                }
                guard authResult != nil , error == nil else {
                    print("Facebook credential login failed, MFA maybe needed")
                    return
                }
                
                print("Succesfully logged user in")
                strongSelf.navigationController?.dismiss(animated: true, completion: nil)
            })
        })
    }
}

