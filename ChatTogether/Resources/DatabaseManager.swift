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
    
    static func safeEmail(emailAddress: String)->String{
        var safeEmail = emailAddress.replacingOccurrences(of: ".", with: "_")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        return safeEmail
    }
    
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
    public func insertUser(with user:ChatTogetherAppUser, completion : @escaping (Bool) -> Void)
    {
        //,"Email_address":user.emailAdress
        database.child(user.safeEmail).setValue(["User_name":user.userName],withCompletionBlock: {[weak self] error, _ in
            guard let strongSelf = self else {
                return
            }
            
            guard error == nil else {
                print("failed ot write to database")
                completion(false)
                return
            }
            
            strongSelf.database.child("user").observeSingleEvent(of: .value, with: { snapshot in
                if var usersCollection = snapshot.value as? [[String: String]] {
                    // append to user dictionary
                    let newElement = [ "userName": user.userName,"emailAddress": user.safeEmail]
                    usersCollection.append(newElement)
                    
                    strongSelf.database.child("users").setValue(usersCollection, withCompletionBlock: { error, _ in
                        guard error == nil else {
                            completion(false)
                            return
                        }
                        completion(true)
                    })
                }
                else{
                    // create that array
                   
                    let newCollection: [[String: String]] = [[ "userName": user.userName, "emailAddress": user.safeEmail ]]
                    
                    strongSelf.database.child("users").setValue(newCollection,withCompletionBlock: { error, _ in
                        guard error == nil else {
                            completion(false)
                            return
                        }
                        completion(true)
                    })
                }
            })
            
            completion(true)
        })
    }
    
    /// Gets all users from database
    public func getAllUsers(completion: @escaping (Result<[[String: String]], Error>) -> Void) {
        database.child("users").observeSingleEvent(of: .value, with: { snapshot in
            guard let value = snapshot.value as? [[String: String]] else {
                completion(.failure(DatabaseError.failedToFetch))
                return
            }
            
            completion(.success(value))
        })
    }
    
    public enum DatabaseError: Error {
        case failedToFetch
        
        public var localizedDescription: String {
            switch self {
            case .failedToFetch:
                return "This means blah failed"
            }
        }
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
    
    var profilePictureFileName:String {
        //afraz9-gmail-com_profile_picture.png
        return "\(safeEmail)_profile_picture.png"
    }
}
