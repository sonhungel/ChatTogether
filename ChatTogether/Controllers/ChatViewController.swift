//
//  ChatViewController.swift
//  ChatTogether
//
//  Created by Trần Sơn on 25/11/2020.
//

import UIKit
import MessageKit


class ChatViewController: MessagesViewController{
    
    private var messages = [Message]()
    
    private var selfSender = Sender(photoURL: "", senderId: "", displayName: "")

    override func viewDidLoad() {
        super.viewDidLoad()

        messages.append(Message(sender: selfSender, messageId: "1", sentDate: Date(), kind: .text("Hello")))
        messages.append(Message(sender: selfSender, messageId: "1", sentDate: Date(), kind: .text("Hellasjdasbjhfasdao")))
        
//        self.view.backgroundColor = .red
        
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
    }
}

extension ChatViewController: MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate {
    
    func currentSender() -> SenderType {
        return selfSender
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        messages.count
    }
    
    
}
