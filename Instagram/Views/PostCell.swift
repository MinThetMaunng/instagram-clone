//
//  PostCell.swift
//  Instagram
//
//  Created by Min Thet Maung on 25/02/2020.
//  Copyright © 2020 Myanmy. All rights reserved.
//

import UIKit

class PostCell: UITableViewCell {
    
    var post: Post? {
        didSet {
            userNameLabel.text = post?.user?.username ?? "Unknown User"
            if let profileUrl = post?.user?.profileImage {
                userProfileImage.loadImageUsingUrl(string: "\(PROFILE_IMAGE_URL)\(profileUrl)")
            }
            postedTimeLabel.text = post?.createdAt ?? "Just Now"
            if let imageUrl = post?.photo {
                postImage.loadImageUsingUrl(string: "\(PHOTO_IMAGE_URL)\(imageUrl)")
            }
            
            statusLabel.text = post?.status ?? ""

        }
    }
    
    let userNameLabel: UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 1
        lbl.backgroundColor = .clear
        lbl.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        return lbl
    }()
    
    let userProfileImage: CacheImageView = {
        let iv = CacheImageView()
//        iv.image = UIImage(named: "unknown_user")
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 20
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        return iv
    }()
    
    let postImage: CacheImageView = {
        let iv = CacheImageView()
        iv.image = UIImage(named: "gray")
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = #colorLiteral(red: 0.937254902, green: 0.937254902, blue: 0.937254902, alpha: 1)
        iv.layer.masksToBounds = true
        return iv
    }()
    
    let postedTimeLabel: UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 1
        lbl.backgroundColor = .clear
        lbl.font = UIFont.systemFont(ofSize: 10, weight: .bold)
        return lbl
    }()
    
    private func calculateImageSize(imageView: UIImageView) -> CGSize {
        let screenWidth = self.frame.size.width
        let imageWidth = imageView.frame.size.width
        let imageHeight = imageView.frame.size.height
        
        let scale: CGFloat = imageWidth > screenWidth ? screenWidth / imageWidth : screenWidth / imageWidth
        let size = CGSize(width: imageWidth * scale, height: imageHeight * scale)
        print("After")
        print("image width = \(imageWidth * scale)")
        print("image height = \(imageHeight * scale)")
        return size
    }
    
    private func estimageSize(text: String) -> CGRect {
        let size = CGSize(width: frame.width - 32, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin)
        let estimateRect = NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 18, weight: .regular)], context: nil)
        return estimateRect
    }
    
    let statusLabel: UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 0
        lbl.backgroundColor = .clear
        lbl.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        return lbl
    }()
    
    lazy var likeButton: UIButton = createImageButton(imageName: "love")
    lazy var commentButton: UIButton = createImageButton(imageName: "comment")
    lazy var shareButton: UIButton = createImageButton(imageName: "share")
    
    private func createImageButton(imageName: String) -> UIButton {
        let btn = UIButton(type: .system)
        let img = UIImage(named: imageName)?.withRenderingMode(.alwaysTemplate)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        btn.tintColor = .gray
        btn.setImage(img, for: .normal)
        return btn
    }
    
    lazy var stackView: UIStackView = {
        let sv = UIStackView()
        [self.likeButton, self.commentButton, self.shareButton].forEach { (btn) in
            sv.addArrangedSubview(btn)
        }
        sv.distribution = .equalCentering
        sv.axis = .horizontal
        return sv
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        createObserver()
        setupViews()
    }
    
    private func setupViews() {
        backgroundColor = .clear
        
        addSubview(userNameLabel)
        addSubview(userProfileImage)
        addSubview(postedTimeLabel)
        addSubview(postImage)
        addSubview(stackView)
        addSubview(statusLabel)
        
        constraintWithVisualFormat(format: "H:|-16-[v0(40)]-8-[v1]-16-|", views: userProfileImage, userNameLabel)
        constraintWithVisualFormat(format: "H:|-16-[v0(40)]-8-[v1]-16-|", views: userProfileImage, postedTimeLabel)
        constraintWithVisualFormat(format: "H:|[v0]|", views: postImage)
        constraintWithVisualFormat(format: "H:|-16-[v0(90)]", views: stackView)
        constraintWithVisualFormat(format: "H:|-16-[v0]-16-|", views: statusLabel)
        constraintWithVisualFormat(format: "V:|-16-[v0(40)]-12-[v1]-12-[v2(\(frame.size.width+50))]-12-[v3(30)]-10-|", views: userProfileImage, statusLabel, postImage, stackView)
        constraintWithVisualFormat(format: "V:|-16-[v0(20)]-5-[v1(15)]-12-[v2]-12-[v3(\(frame.size.width+50))]-12-[v4(30)]-10-|", views: userNameLabel, postedTimeLabel, statusLabel, postImage, stackView)
    }
    
    private func createObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(changeToDarkMode), name: CHANGE_TO_DARK, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(changeToLightMode), name: CHANGE_TO_LIGHT, object: nil)
    }
    
    @objc private func changeToDarkMode() {
        userNameLabel.textColor = UIColor(white: 0.9, alpha: 1)
        statusLabel.textColor = UIColor(white: 0.9, alpha: 1)
        likeButton.tintColor = UIColor(white: 0.9, alpha: 1)
        commentButton.tintColor = UIColor(white: 0.9, alpha: 1)
        shareButton.tintColor = UIColor(white: 0.9, alpha: 1)
        postedTimeLabel.textColor = UIColor(white: 1, alpha: 0.6)
    }
    
    @objc private func changeToLightMode() {
        userNameLabel.textColor = .darkGray
        statusLabel.textColor = .darkGray
        likeButton.tintColor = .gray
        commentButton.tintColor = .gray
        shareButton.tintColor = .gray
        postedTimeLabel.textColor = .gray
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

