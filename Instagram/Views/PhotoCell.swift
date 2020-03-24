//
//  PhotoCell.swift
//  Instagram
//
//  Created by Min Thet Maung on 23/03/2020.
//  Copyright © 2020 Myanmy. All rights reserved.
//

import UIKit

class PhotoCell: UICollectionViewCell {
    
    var data: UserPost? {
        didSet {
            if let photoUrl = data?.photo {
                photoView.loadImageUsingUrl(string: "\(PHOTO_IMAGE_URL)\(photoUrl)")
//                self.layoutIfNeeded()
//                isHidden = false
            }
        }
    }
    
    let photoView: CacheImageView = {
        let iv = CacheImageView()
//        iv.contentMode = .scaleAspectFit
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
//        isHidden = true
        addSubview(photoView)
        
        constraintWithVisualFormat(format: "H:|[v0]|", views: photoView)
        constraintWithVisualFormat(format: "V:|-0.5-[v0]-0.5-|", views: photoView)
    }
}
