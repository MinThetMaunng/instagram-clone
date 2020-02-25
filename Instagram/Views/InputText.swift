//
//  InputText.swift
//  Instagram
//
//  Created by Min Thet Maung on 25/02/2020.
//  Copyright © 2020 Myanmy. All rights reserved.
//

import UIKit

class InputText: UITextField {
    
    private let height: CGFloat
    private let padding: CGFloat
    private let placeholderString: String
    
    let errorMessageLabel: UILabel = {
        let label = UILabel()
        label.textColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.text = ""
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        label.backgroundColor = UIColor.clear
        return label
    }()

    init(padding: CGFloat, height: CGFloat, placeholder: String) {
        self.height = height
        self.padding = padding
        self.placeholderString = placeholder
        
        super.init(frame: .zero)
        
        setupDesign()
        setupErrorMessage()
    }
    
    private func setupDesign() {
        layer.borderColor = UIColor.white.cgColor
        alpha = 0.4
        layer.borderWidth = 3
        layer.cornerRadius = height / 2
        autocapitalizationType = .none
        backgroundColor = .clear
        attributedPlaceholder = NSAttributedString(string: placeholderString, attributes: [NSAttributedString.Key.foregroundColor : UIColor(white: 1, alpha: 1)])
        font = UIFont.boldSystemFont(ofSize: 16)
        textColor = .white
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupErrorMessage() {
        addSubview(errorMessageLabel)
        errorMessageLabel.widthAnchor.constraint(equalTo: widthAnchor, constant: -padding).isActive = true
        errorMessageLabel.heightAnchor.constraint(equalToConstant: 15).isActive = true
        errorMessageLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: padding).isActive = true
        errorMessageLabel.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        errorMessageLabel.topAnchor.constraint(equalTo: bottomAnchor, constant: -18).isActive = true
    }
    
    func showErrorMessage() {
        errorMessageLabel.isHidden = false
        errorMessageLabel.text = "\(placeholderString) must not be empty!"
    }
    
    func hideErrorMessage() {
        errorMessageLabel.isHidden = true
        errorMessageLabel.text = ""
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: padding, dy: 0)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: padding, dy: 0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 0, height: height)
    }
    
}

