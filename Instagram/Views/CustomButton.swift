//
//  CustomButton.swift
//  Instagram
//
//  Created by Min Thet Maung on 29/02/2020.
//  Copyright © 2020 Myanmy. All rights reserved.
//

import UIKit

class CustomButton: UIButton {

    init(title: String) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        setTitle(title, for: .normal)
        setTitleColor(.white, for: .normal)
        titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        layer.cornerRadius = 3
        layer.masksToBounds = true
        backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
