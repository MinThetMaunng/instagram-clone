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
            }
        }
    }
    
    let photoView: CacheImageView = {
        let iv = CacheImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = #colorLiteral(red: 0.937254902, green: 0.937254902, blue: 0.937254902, alpha: 1)
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
        addSubview(photoView)
        
        constraintWithVisualFormat(format: "H:|[v0]|", views: photoView)
        constraintWithVisualFormat(format: "V:|-0.5-[v0]-0.5-|", views: photoView)
    }
}
