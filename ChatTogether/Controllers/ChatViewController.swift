//
//  ChatViewController.swift
//  ChatTogether
//
//  Created by Trần Sơn on 25/11/2020.
//

import UIKit
import MessageKit
import InputBarAccessoryView


class ChatViewController: MessagesViewController{
    
    public static let dateFormatter: DateFormatter = {
        let formattre = DateFormatter()
        formattre.dateStyle = .medium
        formattre.timeStyle = .long
        formattre.locale = .current
        return formattre
    }()
    
    public let otherUserEmail: String
    private var conversationId: String?
    public var isNewConversation = false
    
    private var messages = [Message]()
    
    private var selfSender: Sender? {
        guard let email = UserDefaults.standard.value(forKey: "email") as? String else {
            return nil
        }
        let safeEmail = DatabaseManager.safeEmail(emailAddress: email)
        
        return Sender(photoURL: "",
                      senderId: safeEmail,
                      displayName: "Me")
    }
    
    init(with email: String, id:String?) {
        self.conversationId = id
        self.otherUserEmail = email
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messageInputBar.delegate = self
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        messageInputBar.inputTextView.becomeFirstResponder()
        if let conversationId = conversationId {
            listenForMessages(id: conversationId,shouldScrollToBottom: true)
        }
    }
    
    private func listenForMessages(id: String, shouldScrollToBottom: Bool) {
           DatabaseManager.shared.getAllMessagesForConversation(with: id, completion: { [weak self] result in
               switch result {
               case .success(let messages):
                   print("success in getting messages: \(messages)")
                   guard !messages.isEmpty else {
                       print("messages are empty")
                       return
                   }
                   self?.messages = messages

                DispatchQueue.main.async {
                    self?.messagesCollectionView.reloadDataAndKeepOffset()
                    
                    if shouldScrollToBottom {
                        self?.messagesCollectionView.scrollToBottom()
                    }
                }
               case .failure(let error):
                   print("failed to get messages: \(error)")
               }
           })
       }
}

extension ChatViewController : InputBarAccessoryViewDelegate{
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        guard !text.replacingOccurrences(of: "", with: "").isEmpty, let selfSender = self.selfSender, let messageID = createMessageId() else {
            return
        }
        
        print("Sending :\(text)")
        let message = Message(sender: selfSender, messageId: messageID, sentDate: Date(), kind: .text(text))

        // send message
        if isNewConversation {
            // Need to create new conv on Database
            DatabaseManager.shared.createNewConversation(with: otherUserEmail,name: self.title ?? "User", firstMessage: message, completion: { [weak self]success in
                if success {
                    print("message sent")
                    self?.isNewConversation = false
                }
                else {
                    print("faield ot send")
                }
            })
        }
        else{
            // append to existing conversation data
            
            guard let conversationID = conversationId, let name = self.title else {
                return
            }
            DatabaseManager.shared.sendMessage(to: conversationID, otherUserEmail:otherUserEmail , name: name, newMessage: message, completion: {success in
                if success {
                    print("message sent")
                    
                }
                else {
                    print("faield ot send")
                }
            })
        }
    }
    
    private func createMessageId() -> String?{
        // date, otherUesrEmail, senderEmail, randomInt
        guard let currentUserEmail = UserDefaults.standard.value(forKey: "email") as? String else {
            return nil
        }
        
        let safeCurrentEmail = DatabaseManager.safeEmail(emailAddress: currentUserEmail)
        
        let dateString = Self.dateFormatter.string(from: Date())
        let newIdentifier = "\(otherUserEmail)_\(safeCurrentEmail)_\(dateString)"
        
        print("created message id: \(newIdentifier)")
        
        return newIdentifier
    }
}

extension ChatViewController: MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate {
    
    func currentSender() -> SenderType {
        if let sender = selfSender {
            return sender
        }
        fatalError("SelfSender is nill, email should be cached")
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    
    
}
