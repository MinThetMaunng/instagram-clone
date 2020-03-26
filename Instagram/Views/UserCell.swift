//
//  UserCell.swift
//  Instagram
//
//  Created by Min Thet Maung on 26/03/2020.
//  Copyright © 2020 Myanmy. All rights reserved.
//

import UIKit

class UserCell: UICollectionViewCell {
    
    var userData: User? {
        didSet {
            if let profileImageUrl = userData?.profileImage {
                profileImage.loadImageUsingUrl(string: "\(PROFILE_IMAGE_URL)\(profileImageUrl)")
            }
            if let username = userData?.username {
                userName.text = username
            }
        }
    }
    
    let profileImage: CacheImageView = {
        let iv = CacheImageView()
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = #colorLiteral(red: 0.937254902, green: 0.937254902, blue: 0.937254902, alpha: 1)
        iv.layer.cornerRadius = 25
        iv.clipsToBounds = true
        return iv
    }()
    
    let userName: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        lbl.numberOfLines = 1
        return lbl
    }()
    
    let followStatus: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .lightGray
        lbl.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        lbl.numberOfLines = 1
        lbl.text = "following"
        return lbl
    }()
    
    private func setupViews() {
        addSubview(profileImage)
        addSubview(userName)
        addSubview(followStatus)
        
        constraintWithVisualFormat(format: "H:|-16-[v0(50)]-12-[v1]|", views: profileImage, userName)
        constraintWithVisualFormat(format: "H:|-16-[v0(50)]-12-[v1]|", views: profileImage, followStatus)
        constraintWithVisualFormat(format: "V:|-16-[v0(50)]-16-|", views: profileImage)
        
        constraintWithVisualFormat(format: "V:|-20-[v0(21)][v1(21)]-20-|", views: userName, followStatus)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
