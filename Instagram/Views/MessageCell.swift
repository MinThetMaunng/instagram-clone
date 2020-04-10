//
//  MessageCell.swift
//  Instagram
//
//  Created by Min Thet Maung on 09/04/2020.
//  Copyright © 2020 Myanmy. All rights reserved.
//

import UIKit

class MessageCell: UICollectionViewCell {
    
    let messageLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        lbl.text = "Hello, It is me Juric Daniel"
        lbl.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        lbl.backgroundColor = .clear
        lbl.numberOfLines = 0
        return lbl
    }()
    
    let textBubbleView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor(white: 0.95, alpha: 1)
        v.layer.cornerRadius = 20
        v.layer.masksToBounds = true
        return v
    }()
    
    let profileImage: CacheImageView = {
        let iv = CacheImageView()
        iv.contentMode = .scaleAspectFill
        iv.image = UIImage(named: "poe_mamhe_thar")
        iv.layer.cornerRadius = 15
        iv.layer.masksToBounds = true
        return iv
    }()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
   
    
    fileprivate func setupViews() {
        addSubview(textBubbleView)
        addSubview(messageLabel)
//        addSubview(profileImage)
        
//        constraintWithVisualFormat(format: "H:|[v0]|", views: messageTextView)
//        constraintWithVisualFormat(format: "V:|[v0]|", views: messageTextView)
        
//        constraintWithVisualFormat(format: "H:|-16-[v0(30)]", views: profileImage)
//        constraintWithVisualFormat(format: "V:[v0(30)]|", views: profileImage)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
