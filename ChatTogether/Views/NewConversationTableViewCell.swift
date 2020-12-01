//
//  NewConversationCell.swift
//  ChatTogether
//
//  Created by Trần Sơn on 01/12/2020.
//

import Foundation


import UIKit
import SnapKit
import SDWebImage

class NewConversationTableViewCell: UITableViewCell {
    static let identifier = "NewConversationCell"
    
    private let userImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 35
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private let userNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 21, weight: .semibold)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(userImageView)
        contentView.addSubview(userNameLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
        userImageView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(contentView.snp.top).offset(10)
            make.leading.equalTo(contentView.snp.leading).offset(10)
            make.size.equalTo(CGSize(width: 100, height: 100))
        }
        
        userNameLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(contentView.snp.top)
            make.leading.equalTo(userImageView.snp.trailing).offset(10)
            make.trailing.equalTo(contentView.snp.trailing)
            make.size.equalTo(CGSize(width: contentView.frame.width - 20 - userImageView.frame.width,
                                     height: (contentView.frame.height-20)/2))
        }

    }
    
    public func configure(with model: SearchResult) {
        userNameLabel.text = model.userName
        
        let path = "images/\(model.emailAddress)_profile_picture.png"
        StorageManager.shared.downloadURL(for: path, completion: { [weak self] result in
            switch result {
            case .success(let url):
                
                DispatchQueue.main.async {
                    self?.userImageView.sd_setImage(with: url, completed: nil)
                }
                
            case .failure(let error):
                print("failed to get image url: \(error)")
            }
        })
    }
    
}
