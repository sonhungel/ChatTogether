//
//  RegisterViewController.swift
//  ChatTogether
//
//  Created by Trần Sơn on 11/8/20.
//

import UIKit
import SnapKit
import FirebaseAuth
import JGProgressHUD

class SignUpViewController: UIViewController {
    
    private let spinner = JGProgressHUD(style: .dark)
    
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
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        
        return button
        
    }()
    
    private let questionLabel:UILabel = {
        let label = UILabel()
        label.text = "Already have an Account?"
        label.textAlignment = .center
        label.textColor = UIColor(red: 95/255, green: 78/255, blue: 128/255, alpha: 1)
        label.font = UIFont(name: "Geeza Pro", size: 16)
        return label
    }()
    private let signInButton:UIButton = {
        
        let button = UIButton()
        button.setTitle("Sign In", for: .normal)
        button.setTitleColor(UIColor(red: 98/255, green: 58/255, blue: 154/255, alpha: 0.9), for: .normal)
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
        return button

    }()
     
    private let imageBackground:UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "signup")
        //        imageView.backgroundColor = .black
        return imageView
    }()
    
    private let profileImage = UIImageView()
    
    private let imageDecorTop:UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "signup_top")
        
        return imageView
    }()
    
    private let imageDecorBottom:UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "main_bottom")
        return imageView
    }()
    
    private let emailTextField:UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 30
        field.placeholder = "Your Email"
        field.leftViewMode = .always
        field.backgroundColor = UIColor(red: 239/255, green: 232/255, blue: 253/255, alpha: 1)
        field.attributedPlaceholder = NSAttributedString(string: "Your Email",
                                                         attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
        return field
        
    }()
    
    private let passwordTextField:UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .done
        field.layer.cornerRadius = 30
        field.placeholder = "Your Password"
        field.leftViewMode = .always
        field.backgroundColor = UIColor(red: 239/255, green: 232/255, blue: 253/255, alpha: 1)
        field.attributedPlaceholder = NSAttributedString(string: "Your Email",
                                                         attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
        field.isSecureTextEntry = true
        return field
    }()
    
    private let userNameTextField:UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .done
        field.layer.cornerRadius = 30
        field.placeholder = "Your Name"
        field.leftViewMode = .always
        field.rightViewMode = .always
        field.backgroundColor = UIColor(red: 239/255, green: 232/255, blue: 253/255, alpha: 1)
        field.attributedPlaceholder = NSAttributedString(string: "Your Name",
                                                         attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
        return field
    }()
    
    private let addImageButton:UIButton = {
 
        let addImageButton = UIButton()
        var imageButton = UIImage(named: "icon_addImage")
        addImageButton.setImage(imageButton, for: .normal)
        return addImageButton
    }()
    
    private let imageEmail:UIView = {
        let view = UIView()
        view.frame.size = CGSize(width: 40, height: 20)
        let imageView = UIImageView(image: UIImage(named: "icon_email"))
        imageView.image = imageView.image?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = UIColor(red: 98/255, green: 58/255, blue: 154/255, alpha: 0.9)
        imageView.center = view.center
        view.addSubview(imageView)
        return view
    }()
    
    private let imagePass:UIView = {
        let view = UIView()
        view.frame.size = CGSize(width: 40, height: 20)
        let imageView = UIImageView(image: UIImage(named: "icon_pass"))
        imageView.image = imageView.image?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = UIColor(red: 98/255, green: 58/255, blue: 154/255, alpha: 0.9)
        imageView.center = view.center
        view.addSubview(imageView)
        return view
    }()
    
    private let imageUser:UIView = {
        let view = UIView()
        view.frame.size = CGSize(width: 40, height: 20)
        let imageView = UIImageView(image: UIImage(named: "icon_user"))
        imageView.image = imageView.image?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = UIColor(red: 98/255, green: 58/255, blue: 154/255, alpha: 0.9)
        imageView.center = view.center
        view.addSubview(imageView)
        return view
    }()
    
    private let orDivider:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 235/255, green: 230/255, blue: 245/255, alpha: 2)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        view.addSubview(imageBackground)
        view.addSubview(imageDecorTop)
        view.addSubview(imageDecorBottom)
        view.addSubview(signUpText)
        view.addSubview(userNameTextField)
        
        userNameTextField.rightView = addImageButton
        userNameTextField.leftView = imageUser
        
        view.addSubview(emailTextField)
        emailTextField.leftView = imageEmail
        view.addSubview(passwordTextField)
        passwordTextField.leftView = imagePass
        view.addSubview(signUpButton)
        view.addSubview(questionLabel)
        view.addSubview(signInButton)
        view.addSubview(orDivider)
        
        signInButton.addTarget(self, action: #selector(signinButtonTapped), for: .touchUpInside)// to go back signIn page
        signUpButton.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
        
        addImageButton.addTarget(self, action: #selector(didTapAddImageProfile), for: .touchUpInside)
        
        userNameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        hideKeyboardWhenTappedAround()
 
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        userNameTextField.becomeFirstResponder()
    }
    
    //    autolayout
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        imageBackground.snp.makeConstraints { (make) ->Void in
            
            make.top.greaterThanOrEqualTo(view).offset(35)
            make.leading.equalTo(view).offset(45)
            make.trailing.equalTo(view).offset(-45)
            make.bottom.equalTo(view).offset(-400)
        }
        
        imageDecorTop.snp.makeConstraints { (make) ->Void in
            make.top.equalTo(view)
            make.leading.equalTo(view)
            make.size.equalTo(CGSize(width: 130, height: 150))
            
        }
        
        imageDecorBottom.snp.makeConstraints { (make) ->Void in
            make.size.equalTo(CGSize(width: 170, height: 150))
            make.leading.equalTo(view)
            make.bottom.equalTo(view)
        }
        
        userNameTextField.snp.makeConstraints { (make) ->Void in
            make.top.greaterThanOrEqualTo(imageBackground.snp.bottom).offset(5)
            make.height.equalTo(60)
            make.leading.equalTo(view).offset(55)
            make.trailing.equalTo(view).offset(-55)
        }
        
        emailTextField.snp.makeConstraints { (make) ->Void in
            make.top.greaterThanOrEqualTo(userNameTextField.snp.bottom).offset(5)
            make.height.equalTo(60)
            make.leading.equalTo(view).offset(55)
            make.trailing.equalTo(view).offset(-55)
        }
        passwordTextField.snp.makeConstraints { (make) ->Void in
            make.top.greaterThanOrEqualTo(emailTextField.snp.bottom).offset(5)
            make.height.equalTo(60)
            make.leading.equalTo(view).offset(55)
            make.trailing.equalTo(view).offset(-55)
        }
        
        signUpButton.translatesAutoresizingMaskIntoConstraints = false
        signUpButton.snp.makeConstraints { (make) ->Void in
            make.top.greaterThanOrEqualTo(passwordTextField.snp.bottom).offset(10)
            make.leading.equalTo(view).offset(55)
            make.trailing.equalTo(view).offset(-55)
            //make.bottom.lessThanOrEqualTo(self.view.snp.bottom).offset(-100)
            make.height.equalTo(60)
        }
        
        
        signUpText.snp.makeConstraints { (make) ->Void in
            make.top.greaterThanOrEqualTo(imageBackground.snp.top).offset(-25)
            make.size.equalTo(CGSize(width: 300, height: 50))
            make.leading.equalTo(view).offset(40)
            make.trailing.equalTo(view).offset(-40)
        }
        
        questionLabel.snp.makeConstraints { (make) ->Void in
            make.top.equalTo(signUpButton.snp.bottom).offset(15)
            make.centerX.equalTo(view.snp.centerX).offset(-30)
            //make.trailing.equalTo(self.view).offset(-40)
        }
        signInButton.snp.makeConstraints { (make) ->Void in
            make.top.equalTo(signUpButton.snp.bottom).offset(6)
            make.leading.equalTo(questionLabel.snp.trailing).offset(5)
        }
        orDivider.snp.makeConstraints { (make) ->Void in
            make.top.equalTo(questionLabel.snp.bottom).offset(10)
            make.size.equalTo(CGSize(width: 250, height: 1))
            make.centerX.equalTo(view.snp.centerX)
        }
        
    }
    
    @objc private func signUpButtonTapped()
    {
        userNameTextField.resignFirstResponder()
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        
        guard let email = emailTextField.text,let pass = passwordTextField.text,let userName = userNameTextField.text,!email.isEmpty, !pass.isEmpty,!userName.isEmpty, pass.count >= 6 else {
            alertUserLoginError()
            return
        }
        
        spinner.show(in: view)
        
        // firebase sign up
        
        DatabaseManager.shared.userExists(with: email, completion: { [weak self ]exists in
            guard let strongSelf = self else {
                return
            }
            DispatchQueue.main.async {
                strongSelf.spinner.dismiss()
            }
            
            guard !exists else
            {
                /// This user already exists
                strongSelf.alertUserLoginError(message: "Looks like a user account for that email address already exists!")
                return
            }
            FirebaseAuth.Auth.auth().createUser(withEmail: email, password: pass) { authResult, error in
                
                guard  authResult != nil , error == nil else {
                    print("Error creating user")
                    return
                }
                
                UserDefaults.standard.setValue(email, forKey: "email")
                UserDefaults.standard.setValue(userName, forKey: "name")
                
                let chatUser = ChatTogetherAppUser(userName: userName, emailAdress: email)
                DatabaseManager.shared.insertUser(with: chatUser, completion: {success in
                    if success {
                        // upload image
                        guard let image = strongSelf.profileImage.image, let data = image.pngData() else {
                            return
                        }
                        let fileName = chatUser.profilePictureFileName
                        StorageManager.shared.uploadProfilePicture(with: data, fileName: fileName, completion: { result in
                            switch result {
                            case .success(let downloadUrl):
                                UserDefaults.standard.set(downloadUrl, forKey: "profile_picture_url")
                                print(downloadUrl)
                            case .failure(let error):
                                print("Storage maanger error: \(error)")
                            }
                        })
                    }
                })
                let user = authResult?.user
                print("Create user :\(String(describing: user))")
                
                strongSelf.navigationController?.dismiss(animated: true, completion: nil)
            }
        })
    }
    
    @objc private func signinButtonTapped()
    {
        navigationController?.popViewController(animated: true)
    }
    
    func alertUserLoginError(message:String = "Please enter all information to create a new account.") {
        let alert = UIAlertController(title: "Woops",
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title:"Dismiss",
                                      style: .cancel, handler: nil))
        present(alert, animated: true)
    }
    
    @objc private func didTapAddImageProfile(){
        presentPhotoActionSheet()
    }
    
}

extension SignUpViewController:UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == userNameTextField
        {
            emailTextField.becomeFirstResponder()
        }
        else if textField == emailTextField
        {
            passwordTextField.becomeFirstResponder()
        }
        else if textField == passwordTextField
        {
            signUpButtonTapped()
        }
        return true
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SignUpViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
}

extension SignUpViewController:UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func presentPhotoActionSheet()
    {
        let actionSheet = UIAlertController(title: "Profile Picture", message: "How would you like to select picture?", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: { [weak self ] _ in
            self?.presentCamera()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Choose Photo", style: .default, handler: { [weak self] _ in
            self?.presentPhotoPicker()
        }))
        
        present(actionSheet, animated: true, completion: nil)
    }
    
    func presentCamera()
    {
        let viewController = UIImagePickerController()
        viewController.sourceType = .camera
        viewController.delegate = self
        viewController.allowsEditing = true
        present(viewController, animated: true, completion: nil)
    }
    
    func presentPhotoPicker()
    {
        let viewController = UIImagePickerController()
        viewController.sourceType = .photoLibrary
        viewController.delegate = self
        viewController.allowsEditing = true
        present(viewController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        picker.dismiss(animated: true, completion: nil)
        guard let selectedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            return
        }
        profileImage.image = selectedImage
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
