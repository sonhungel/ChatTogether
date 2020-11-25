//
//  AppDelegate.swift
//  ChatTogether
//
//  Created by Trần Sơn on 11/7/20.
//

import UIKit
import Firebase
import FBSDKCoreKit
import GoogleSignIn

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,GIDSignInDelegate {
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        ApplicationDelegate.shared.application( application, didFinishLaunchingWithOptions: launchOptions )
        
        GIDSignIn.sharedInstance()?.clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance()?.delegate = self
        return true
    }

    func application( _ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:] ) -> Bool
    {
        ApplicationDelegate.shared.application( app, open: url, sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplication.OpenURLOptionsKey.annotation] )
        
        return GIDSignIn.sharedInstance().handle(url)
    }
    
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        guard error == nil else {
            if let error = error
            {
                print("Failed to sign in with Google: \(error)")
                
            }
            return
        }
        guard let user = user else {
            return
        }
        
        print("Sign In with google : \(user)")
        
        guard let email = user.profile.email, let userName = user.profile.name else {
            return
        }
        
        DatabaseManager.shared.userExists(with: email, completion: { exist in
            if !exist {
                // insert user to database
                
                let chatUser = ChatTogetherAppUser(userName: userName, emailAdress: email)
                DatabaseManager.shared.insertUser(with: chatUser, completion: {success in
                    if success {
                        // upload image
                        if user.profile.hasImage {
                            guard let url = user.profile.imageURL(withDimension: 200) else {
                                return
                            }
                            
                            URLSession.shared.dataTask(with: url, completionHandler: { data, _, _ in
                                guard let data = data else {
                                    return
                                }
                                
                                let filename = chatUser.profilePictureFileName
                                StorageManager.shared.uploadProfilePicture(with: data, fileName: filename, completion: { result in
                                    switch result {
                                    case .success(let downloadUrl):
                                        UserDefaults.standard.set(downloadUrl, forKey: "profile_picture_url")
                                        print(downloadUrl)
                                    case .failure(let error):
                                        print("Storage maanger error: \(error)")
                                    }
                                })
                            }).resume()
                        }
                    }
                })
            }
        })
        
        guard let authentication = user.authentication else {
            print("Missing auth object off Google User")
            return }
          let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                            accessToken: authentication.accessToken)
        FirebaseAuth.Auth.auth().signIn(with: credential, completion: { authResult, error in
            guard authResult != nil, error == nil else {
                print("Failed to Sign in with Google credential")
                return
            }
            print("Succesfully Sign in with Google Credential")
            NotificationCenter.default.post(name: .didLogInNotification, object: nil)
        })
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        print("Google user was disconnected")
    }

}
