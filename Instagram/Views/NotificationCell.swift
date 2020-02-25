//
//  NotificationCell.swift
//  Instagram
//
//  Created by Min Thet Maung on 25/02/2020.
//  Copyright © 2020 Myanmy. All rights reserved.
//

import UIKit

class NotificationCell: UITableViewCell {
    
    let userImage: UIImageView = {
        let iv = UIImageView()
        let img = UIImage(named: "mark_zuckerberg")
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 20
        iv.clipsToBounds = true
        iv.image = img
        return iv
    }()
    
    let notiLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Mark Zuckerberg and 33 others like your photo."
        lbl.numberOfLines = 3
        lbl.backgroundColor = .clear
        lbl.textColor = .black
        lbl.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        return lbl
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    private func setupViews() {
        addSubview(userImage)
        addSubview(notiLabel)
        
        constraintWithVisualFormat(format: "H:|-16-[v0(40)]-12-[v1]-16-|", views: userImage, notiLabel)
        constraintWithVisualFormat(format: "V:|-16-[v0(40)]-16-|", views: userImage)
        constraintWithVisualFormat(format: "V:|-16-[v0(40)]-16-|", views: notiLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
