//
//  ConversationTableViewCell.swift
//  ChatTogether
//
//  Created by Trần Sơn on 29/11/2020.
//

import UIKit
import SnapKit
import SDWebImage

class ConversationTableViewCell: UITableViewCell {
    
    static let identifier = "ConversationTableViewCell"
    
    private let userImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 50
        imageView.layer.masksToBounds = true
        //imageView.backgroundColor = .blue
        return imageView
    }()
    
    private let userNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 21, weight: .semibold)
        //label.backgroundColor = .red
        return label
    }()
    
    private let userMessageLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 19, weight: .regular)
        label.numberOfLines = 0
        //label.backgroundColor = .black
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(userImageView)
        contentView.addSubview(userNameLabel)
        contentView.addSubview(userMessageLabel)
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
        userMessageLabel.snp.makeConstraints { (make) ->Void in
            make.top.equalTo(userNameLabel.snp.bottom)
            make.leading.equalTo(userImageView.snp.trailing).offset(10)
            make.trailing.equalTo(contentView.snp.trailing)
            make.bottom.equalTo(contentView.snp.bottom)
        }

    }
    
    public func configure(with model: Conversation) {
        userMessageLabel.text = model.latestMessage.text
        userNameLabel.text = model.name
        
        let path = "images/\(model.otherUserEmail)_profile_picture.png"
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
