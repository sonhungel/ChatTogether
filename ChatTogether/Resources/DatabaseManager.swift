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
    public func createNewConversation(with otherUserEmail: String, name:String, firstMessage:Message , completion: @escaping (Bool) -> Void){
        guard let currentEmail = UserDefaults.standard.value(forKey: "email") as? String else {
            return
        }
        let safeEmail = DatabaseManager.safeEmail(emailAddress: currentEmail)
        
        let ref = database.child("\(safeEmail)")
        
        ref.observeSingleEvent(of: .value, with: {[weak self]snapshot in
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
                "name": name,
                "latest_message": [
                    "date": dateString,
                    "message": message,
                    "is_read": false
                ]
            ]
            
            let recipient_newConversationData: [String: Any] = [
                "id": conversationId,
                "other_user_email": safeEmail,
                "name": "Self",
                "latest_message": [
                    "date": dateString,
                    "message": message,
                    "is_read": false
                ]
            ]
            // Update recipient conversaiton entry
            self?.database.child("\(otherUserEmail)/conversations").observeSingleEvent(of: .value, with: { [weak self] snapshot in
                if var conversations = snapshot.value as? [[String: Any]] {
                    // append
                    conversations.append(recipient_newConversationData)
                    self?.database.child("\(otherUserEmail)/conversations").setValue(conversations)
                }
                else {
                    // create
                    self?.database.child("\(otherUserEmail)/conversations").setValue([recipient_newConversationData])
                }
            })
            
            if var conversations = userNode["conversations"] as? [[String:Any]]{
                // conversation array exists for current user
                // => append
                
                conversations.append(newConversationData)
                
                userNode["conversations"] = conversations
                
                ref.setValue(userNode, withCompletionBlock: {[weak self]error, _ in
                    guard error == nil else {
                        completion(false)
                        return
                    }
                    self?.finishCreatingConversation(name: name, conversationID: conversationId, firstMessage: firstMessage, completion: completion)
                })
                
            }
            else {
                // Conversation array is not exists for current user
                // create it
                userNode["conversations"] = [newConversationData]
                
                ref.setValue(userNode, withCompletionBlock: {[weak self] error, _ in
                    guard error == nil else {
                        completion(false)
                        return
                    }
                    self?.finishCreatingConversation(name: name, conversationID: conversationId, firstMessage: firstMessage, completion: completion)

                })
            }
        })
    }
    
    private func finishCreatingConversation(name:String, conversationID:String, firstMessage: Message, completion: @escaping (Bool) -> Void){
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
        
        
        guard let myEmail = UserDefaults.standard.value(forKey: "email") as? String else {
            completion(false)
            return
        }
        
        let currentUserEmail = DatabaseManager.safeEmail(emailAddress: myEmail)
        
        let collectionMessage: [String: Any] = [
            "id": firstMessage.messageId,
            "type": firstMessage.kind.messageKindString,
            "content": message,
            "date": dateString,
            "sender_email": currentUserEmail,
            "is_read": false,
            "name": name
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
    public func getAllConversations(for email:String, completion: @escaping (Result<[Conversation],Error>) -> Void){
        database.child("\(email)/conversations").observe(.value, with: {snapshot in
            guard let value = snapshot.value as? [[String: Any]] else{
                completion(.failure(DatabaseError.failedToFetch))
                return
            }
            
            let conversations: [Conversation] = value.compactMap({dictionary in
                guard let conversationId = dictionary["id"] as? String,
                      let name = dictionary["name"] as? String,
                      let otherUserEmail = dictionary["other_user_email"] as? String,
                      let latestMessage = dictionary["latest_message"] as? [String: Any],
                      let date = latestMessage["date"] as? String,
                      let message = latestMessage["message"] as? String,
                      let isRead = latestMessage["is_read"] as? Bool else {
                    return nil
                }
                
                let latestMmessageObject = LatestMessage(date: date,
                                                         text: message,
                                                         isRead: isRead)
                return Conversation(id: conversationId,
                                    name: name,
                                    otherUserEmail: otherUserEmail,
                                    latestMessage: latestMmessageObject)
            })
            completion(.success(conversations))
        })
    }
    
    /// Gets all mmessages for a given conversatino
    public func getAllMessagesForConversation(with id: String, completion: @escaping (Result<[Message], Error>) -> Void) {
        database.child("\(id)/messages").observe(.value, with: {snapshot in
            guard let value = snapshot.value as? [[String: Any]] else{
                completion(.failure(DatabaseError.failedToFetch))
                return
            }
            
            let messages: [Message] = value.compactMap({dictionary in
                guard let name = dictionary["name"] as? String,
                      let isRead = dictionary["is_read"] as? Bool,
                      let messageID = dictionary["id"] as? String,
                      let content = dictionary["content"] as? String,
                      let senderEmail = dictionary["sender_email"] as? String,
                      let type = dictionary["type"] as? String,
                      let dateString = dictionary["date"] as? String,
                      let date = ChatViewController.dateFormatter.date(from: dateString)else {
                    return nil
                }
                
                let sender = Sender(photoURL: "",
                                    senderId: senderEmail,
                                    displayName: name)
                return Message(sender: sender,
                               messageId: messageID,
                               sentDate: date,
                               kind: .text(content))
            })
            completion(.success(messages))
        })
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
