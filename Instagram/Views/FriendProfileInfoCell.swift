//
//  FriendInfoCell.swift
//  Instagram
//
//  Created by Min Thet Maung on 27/03/2020.
//  Copyright © 2020 Myanmy. All rights reserved.
//


import UIKit

class FriendProfileInfo: UICollectionViewCell {
    
    var profile: UserProfileData? {
        didSet {
            if let username = profile?.user?.username {
                nameLabel.text = "\(username)"
            }
            if let profileImageString = profile?.user?.profileImage {
                profileImage.loadImageUsingUrl(string: "\(PROFILE_IMAGE_URL)\(profileImageString)")
            }
            if let noOfFllowers = profile?.noOfFollowers {

                let attributedText = NSMutableAttributedString(string: "\(noOfFllowers)", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 20, weight: .semibold), NSAttributedString.Key.foregroundColor: UIColor.black])
                attributedText.append(NSAttributedString(string: "\nFollowers", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14, weight: .regular)]))
                followerLabel.attributedText = attributedText
                
            }
            if let noOfFollowings = profile?.noOfFollowings {
                
                let attributedText = NSMutableAttributedString(string: "\(noOfFollowings)", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 20, weight: .semibold), NSAttributedString.Key.foregroundColor: UIColor.black])
                attributedText.append(NSAttributedString(string: "\nFollowings", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14, weight: .regular)]))
                followingLabel.attributedText = attributedText
                
            }
            if let noOfPosts = profile?.noOfPosts {
                let attributedText = NSMutableAttributedString(string: "\(noOfPosts)", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 20, weight: .semibold), NSAttributedString.Key.foregroundColor: UIColor.black])
                attributedText.append(NSAttributedString(string: "\nPosts", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14, weight: .regular)]))
                postLabel.attributedText = attributedText
            }
            
        }
    }
    
    let profileImage: CacheImageView = {
        let iv = CacheImageView()
//        iv.image = UIImage(named: "juric_daniel")
        iv.backgroundColor = .lightGray
        iv.contentMode = .scaleAspectFit
        iv.layer.cornerRadius = 40
        iv.clipsToBounds = true
        return iv
    }()
    
    let nameLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = ""
        lbl.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        lbl.textColor = .black
        lbl.backgroundColor = .clear
        return lbl
    }()
    
    let followButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setAttributedTitle(NSAttributedString(string: "Follow", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16, weight: .semibold), NSAttributedString.Key.foregroundColor: UIColor.white]), for: .normal)
        btn.layer.borderColor = #colorLiteral(red: 0, green: 0.5843137255, blue: 0.9647058824, alpha: 1)
        btn.backgroundColor = #colorLiteral(red: 0, green: 0.5843137255, blue: 0.9647058824, alpha: 1)
        btn.tintColor = .white
        btn.layer.borderWidth = 0.5
        btn.layer.cornerRadius = 3
        btn.clipsToBounds = true
        return btn
    }()
    
    let messageButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setAttributedTitle(NSAttributedString(string: "Message", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16, weight: .semibold), NSAttributedString.Key.foregroundColor: UIColor.black]), for: .normal)
        btn.layer.borderColor = UIColor.lightGray.cgColor
        btn.layer.borderWidth = 0.5
        btn.layer.cornerRadius = 3
        btn.clipsToBounds = true
        return btn
    }()
    
    func setStatus(status: Bool) {
        let text: String = status ? "Following" : "Follow"
        let borderColor: UIColor = status ? .lightGray : #colorLiteral(red: 0, green: 0.5843137255, blue: 0.9647058824, alpha: 1)
        let foregroundColor: UIColor = status ? #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) : #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        let backgroundColor: UIColor = status ? #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0) : #colorLiteral(red: 0, green: 0.5843137255, blue: 0.9647058824, alpha: 1)
        
        self.followButton.setAttributedTitle(NSAttributedString(string: text, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16, weight: .semibold), NSAttributedString.Key.foregroundColor: foregroundColor]), for: .normal)
        self.followButton.layer.borderColor = borderColor.cgColor
        self.followButton.backgroundColor = backgroundColor
        
    }
    
    let dividerLine: UIView = {
        let v = UIView()
        v.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.3965377391)
        return v
    }()
    
    let dividerLine2: UIView = {
        let v = UIView()
        v.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.3965377391)
        return v
    }()
    
    private func createLabel(number: Int, caption: String) -> UILabel {
        let lbl = UILabel()
        lbl.textColor = .darkGray
        lbl.numberOfLines = 2
        lbl.textAlignment = .center
        lbl.backgroundColor = .clear
        let attributedText = NSMutableAttributedString(string: "\(number)", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 20, weight: .semibold), NSAttributedString.Key.foregroundColor: UIColor.black])
        attributedText.append(NSAttributedString(string: "\n\(caption)", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14, weight: .regular)]))
        lbl.attributedText = attributedText
        return lbl
    }
    
    lazy var postLabel: UILabel = createLabel(number: 0, caption: "Posts")
    lazy var followerLabel: UILabel = createLabel(number: 0, caption: "Followers")
    lazy var followingLabel: UILabel = createLabel(number: 0, caption: "Following")
    
    let feedViewButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.tintColor = .black
        btn.setImage(UIImage(named: "feed_view"), for: .normal)
        return btn
    }()
    
    let gridViewButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.tintColor = .darkGray
        btn.setImage(UIImage(named: "grid_view"), for: .normal)
        return btn
    }()
    
    lazy var stackView: UIStackView = {
        let sv = UIStackView()
        sv.distribution = .fillEqually
        [self.postLabel, self.followerLabel, self.followingLabel].forEach { view in
            sv.addArrangedSubview(view)
        }
        sv.axis = .horizontal
        return sv
    }()
    
    lazy var viewOption: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.distribution = .fillEqually
        sv.addArrangedSubview(self.gridViewButton)
        sv.addArrangedSubview(self.feedViewButton)
        return sv
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    private func setupViews() {
        addSubview(profileImage)
        addSubview(nameLabel)
        addSubview(stackView)
        addSubview(followButton)
        addSubview(messageButton)
        addSubview(dividerLine)
        addSubview(viewOption)
        addSubview(dividerLine2)
        
        constraintWithVisualFormat(format: "H:|-16-[v0(80)]-25-[v1]-16-|", views: profileImage, stackView)
        constraintWithVisualFormat(format: "H:|-16-[v0]-16-|", views: nameLabel)
        constraintWithVisualFormat(format: "H:|-12-[v0(v1)]-8-[v1]-12-|", views: followButton, messageButton)
        constraintWithVisualFormat(format: "H:|[v0]|", views: dividerLine)
        constraintWithVisualFormat(format: "H:|[v0]|", views: viewOption)
        constraintWithVisualFormat(format: "H:|[v0]|", views: dividerLine2)
        
        constraintWithVisualFormat(format: "V:|-16-[v0(80)]-12-[v1(30)]-10-[v2(30)]-16-[v3(0.3)][v4(40)][v5(0.3)]", views: profileImage, nameLabel, followButton,dividerLine, viewOption, dividerLine2)
        
        constraintWithVisualFormat(format: "V:|-31-[v0(50)]-27-[v1(30)]-10-[v2(30)]-16-[v3(0.3)][v4(40)][v5(0.3)]", views: stackView, nameLabel, messageButton, dividerLine, viewOption, dividerLine2)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
