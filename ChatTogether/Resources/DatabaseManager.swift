//
//  DatabaseManager.swift
//  ChatTogether
//
//  Created by Trần Sơn on 19/11/2020.
//

import Foundation
import FirebaseDatabase

final class DatabaseManager
{
    static let shared = DatabaseManager()
    
    private let database = Database.database().reference()
    
//    static func safeEmail(emailAddress: String)->String{
//        var safeEmail = emailAddress.replacingOccurrences(of: ".", with: "_")
//        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
//        return safeEmail
//    }
    
}

// MARK: Account management
extension DatabaseManager{
    
    /// Check if user exists for given email
    /// Parameter
    /// email    : target email to be checked
    /// Completion      : Async closure to return with result
    
    public func userExists(with email:String,completion: @escaping ((Bool)->Void)){
        var safeEmail = email.replacingOccurrences(of: ".", with: "_")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        
        database.child(safeEmail).observeSingleEvent(of: .value, with: { snapshot in
            guard snapshot.value as? String != nil else {
                completion(false)
                return
            }
            completion(true)
        })
        
    }
    
    /// insert new user to the Database
    public func insertUser(with user:ChatTogetherAppUser)
    {
        database.child(user.safeEmail).setValue(["User_name":user.userName,"Email_address":user.emailAdress])
    }
}

struct ChatTogetherAppUser {
    let userName:String
    let emailAdress:String
    
    var safeEmail:String {
        var safeEmail = emailAdress.replacingOccurrences(of: ".", with: "_")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        return safeEmail
    }
}
