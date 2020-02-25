//
//  ChatBoxCell.swift
//  Instagram
//
//  Created by Min Thet Maung on 25/02/2020.
//  Copyright © 2020 Myanmy. All rights reserved.
//

import UIKit

class ChatBoxCell: UITableViewCell {
    
    let userImage: UIImageView = {
        let iv = UIImageView()
        let img = UIImage(named: "mark_zuckerberg")
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 30
        iv.clipsToBounds = true
        iv.image = img
        return iv
    }()
    
    let userNameLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Unknown User"
        lbl.numberOfLines = 1
        lbl.backgroundColor = .clear
        lbl.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        return lbl
    }()
    
    let lastMinLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "0 min"
        lbl.textColor = .systemBlue
        lbl.numberOfLines = 1
        lbl.backgroundColor = .clear
        lbl.textAlignment = .right
        lbl.font = UIFont.systemFont(ofSize: 10, weight: .bold)
        return lbl
    }()
    
    let lastMsgLabel: UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 1
        lbl.textColor = .lightGray
        lbl.backgroundColor = .clear
        lbl.text = "No Message"
        lbl.textColor = .lightGray
        return lbl
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        createObserver()
    }
    
    private func setupViews() {
        addSubview(userImage)
        addSubview(userNameLabel)
        addSubview(lastMsgLabel)
        addSubview(lastMinLabel)
        
        constraintWithVisualFormat(format: "H:|-16-[v0(60)]-12-[v1][v2(70)]-16-|", views: userImage, userNameLabel, lastMinLabel)
        constraintWithVisualFormat(format: "H:|-16-[v0(60)]-12-[v1]-16-|", views: userImage, lastMsgLabel)
        constraintWithVisualFormat(format: "V:|-16-[v0(60)]-16-|", views: userImage)
        constraintWithVisualFormat(format: "V:|-20-[v0(20)]-5-[v1]-20-|", views: userNameLabel, lastMsgLabel)
        constraintWithVisualFormat(format: "V:|-20-[v0(20)]-5-[v1]-20-|", views: lastMinLabel, lastMsgLabel)
    }
    
    var chatBox: ChatBox? {
        didSet {
            userImage.image = UIImage(named: chatBox?.chatUserImage ?? "unknown_user")
            userNameLabel.text = chatBox?.chatUserName ?? "Unknown User"
            lastMinLabel.text = chatBox?.lastMin ?? ""
            lastMsgLabel.text = chatBox?.lastMessage ?? ""
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func changeToDarkMode() {
        userNameLabel.textColor = .white
    }
    
    @objc private func changeToLightMode() {
        userNameLabel.textColor = .black
    }
    
    private func createObserver(){
        NotificationCenter.default.addObserver(self, selector: #selector(changeToDarkMode), name: CHANGE_TO_DARK, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(changeToLightMode), name: CHANGE_TO_LIGHT, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}

