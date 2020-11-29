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
        //
        database.child(user.safeEmail).setValue(["User_name":user.userName,"Email_address":user.emailAdress],withCompletionBlock: {[weak self] error, _ in
            guard let strongSelf = self else {
                return
            }
            
            guard error == nil else {
                print("failed ot write to database")
                completion(false)
                return
            }

            strongSelf.database.child("users").observeSingleEvent(of: .value, with: { snapshot in
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


// MARK: - Sending messages / conversations

extension DatabaseManager{
    
    /*
            "dfsdfdsfds" {
                "messages": [
                    {
                        "id": String,
                        "type": text, photo, video,
                        "content": String,
                        "date": Date(),
                        "sender_email": String,
                        "isRead": true/false,
                    }
                ]
            }
               conversaiton => [
                  [
                      "conversation_id": "dfsdfdsfds"
                      "other_user_email":
                      "latest_message": => {
                        "date": Date()
                        "latest_message": "message"
                        "is_read": true/false
                      }
                  ],
                ]
    */

    
    /// Create new conversation with target user email and firstMessage sent
    public func createNewConversation(with otherUserEmail: String, firstMessage:Message , completion: @escaping (Bool) -> Void){
        guard let currentEmail = UserDefaults.standard.value(forKey: "email") as? String else {
            return
        }
        let safeEmail = DatabaseManager.safeEmail(emailAddress: currentEmail)
        
        let ref = database.child("\(safeEmail)")
        
        ref.observeSingleEvent(of: .value, with: {snapshot in
            guard var userNode = snapshot.value as? [String: Any] else {
                completion(false)
                print("user not found")
                return
            }
            let messageDate = firstMessage.sentDate
            let dateString = ChatViewController.dateFormatter.string(from: messageDate)
            
            var message = ""
            
            switch firstMessage.kind{
            
            case .text(let messageText):
                message = messageText
                break;
            case .attributedText(_):
                break;
            case .photo(_):
                break;
            case .video(_):
                break;
            case .location(_):
                break;
            case .emoji(_):
                break;
            case .audio(_):
                break;
            case .contact(_):
                break;
            case .linkPreview(_):
                break;
            case .custom(_):
                break;
            }
            
            let conversationId = "conversation_\(firstMessage.messageId)"
            
            let newConversationData: [String: Any] = [
                "id": conversationId,
                "other_user_email": otherUserEmail,
                "name": "",
                "latest_message": [
                    "date": dateString,
                    "message": message,
                    "is_read": false
                ]
            ]
            
            if var conversations = userNode["conversations"] as? [[String:Any]]{
                // conversation array exists for current user
                // => append
                
                conversations.append(newConversationData)
                
                userNode["conversations"] = conversations
                
                ref.setValue(userNode, withCompletionBlock: {error, _ in
                    guard error == nil else {
                        completion(false)
                        return
                    }
                    completion(true)
                })
                
            }
            else {
                // Conversation array is not exists for current user

                userNode["conversations"] = [newConversationData]
                
                ref.setValue(userNode, withCompletionBlock: {[weak self] error, _ in
                    guard error == nil else {
                        completion(false)
                        return
                    }
                    self?.finishCreatingConversation(conversationID: conversationId, firstMessage: firstMessage, completion: completion)

                })
            }
        })
    }
    
    private func finishCreatingConversation(conversationID:String, firstMessage: Message, completion: @escaping (Bool) -> Void){
//        {
//            "id": String,
//            "type": text, photo, video,
//            "content": String,
//            "date": Date(),
//            "sender_email": String,
//            "isRead": true/false,
//        }
        let messageDate = firstMessage.sentDate
        let dateString = ChatViewController.dateFormatter.string(from: messageDate)
        
        var message = ""
        
        switch firstMessage.kind{
        
        case .text(let messageText):
            message = messageText
            break;
        case .attributedText(_):
            break;
        case .photo(_):
            break;
        case .video(_):
            break;
        case .location(_):
            break;
        case .emoji(_):
            break;
        case .audio(_):
            break;
        case .contact(_):
            break;
        case .linkPreview(_):
            break;
        case .custom(_):
            break;
        }
        
        
        guard let myEmmail = UserDefaults.standard.value(forKey: "email") as? String else {
            completion(false)
            return
        }
        
        let currentUserEmail = DatabaseManager.safeEmail(emailAddress: myEmmail)
        
        let collectionMessage: [String: Any] = [
            "id": firstMessage.messageId,
            "type": firstMessage.kind.messageKindString,
            "content": message,
            "date": dateString,
            "sender_email": currentUserEmail,
            "is_read": false,
            "name": ""
        ]
        
        let value: [String: Any] = [
            "messages": [
                collectionMessage
            ]
        ]
        print("adding convo: \(conversationID)")
        
        database.child("\(conversationID)").setValue(value, withCompletionBlock: { error, _ in
            guard error == nil else {
                completion(false)
                return
            }
            completion(true)
        })
    }
    
    
    /// Fetches and returns all conversations for the user with passed in email
    public func getAllConversations(for email:String, completion: @escaping (Result<String,Error>) -> Void){
        
    }
    
    /// Gets all mmessages for a given conversatino
    public func getAllMessagesForConversation(with id: String, completion: @escaping (Result<String, Error>) -> Void) {
    }
    
    /// Sends a message with target conversation and message
    public func sendMessage(to conversation: String, otherUserEmail: String, name: String, newMessage: Message, completion: @escaping (Bool) -> Void){
        
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
