//
//  ProfileViewModel.swift
//  ChatTogether
//
//  Created by Trần Sơn on 28/11/2020.
//

import Foundation

enum ProfileViewModelType {
    case info, logout
}

struct ProfileViewModel {
    let viewModelType: ProfileViewModelType
    let title: String
    let handler: (() -> Void)?
}
