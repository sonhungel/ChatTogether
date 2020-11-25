//
//  ChatModels.swift
//  ChatTogether
//
//  Created by Trần Sơn on 25/11/2020.
//

import Foundation
import MessageKit

struct Message: MessageType {
    var sender: SenderType
    var messageId: String
    var sentDate: Date
    var kind: MessageKind
}

struct Sender:SenderType {
    var photoURL : String
    var senderId: String
    var displayName: String
}
