//
//  ModalBox.swift
//  Instagram
//
//  Created by Min Thet Maung on 05/03/2020.
//  Copyright © 2020 Myanmy. All rights reserved.
//

import UIKit

class ModalBox: UIView {
    
    let indicatorView: UIActivityIndicatorView = {
        let ai = UIActivityIndicatorView(style: .large)
        ai.color = .white
        ai.translatesAutoresizingMaskIntoConstraints = false
        return ai
    }()
    
    var captionLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Loading"
        lbl.textColor = .white
        lbl.numberOfLines = 1
        lbl.textAlignment = .center
        lbl.backgroundColor = .clear
        lbl.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    lazy var boxView: UIView = {
        let v = UIView()
        v.backgroundColor = #colorLiteral(red: 0.182870537, green: 0.1829081476, blue: 0.1828655601, alpha: 1)
        v.layer.cornerRadius = 10
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    init() {
        super.init(frame: .zero)
        setupViews()
    }
    
    func add(to view: UIView) {
        pin(to: view)
    }
    
    func show(){
        self.isHidden = false
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            self.alpha = 1.0
        }, completion: nil)
    }
    
    @objc func hide(){
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            self.alpha = 0.0
        }) { complete in
            self.isHidden = true
        }
    }

    private func setupBoxView() {
        boxView.widthAnchor.constraint(equalToConstant: 120).isActive = true
        boxView.heightAnchor.constraint(equalToConstant: 120).isActive = true
        boxView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        boxView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        boxView.addSubview(indicatorView)
        indicatorView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        indicatorView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        indicatorView.topAnchor.constraint(equalTo: boxView.topAnchor, constant: 20).isActive = true
        indicatorView.centerXAnchor.constraint(equalTo: boxView.centerXAnchor).isActive = true
        indicatorView.startAnimating()
        
        boxView.addSubview(captionLabel)
        captionLabel.leftAnchor.constraint(equalTo: boxView.leftAnchor, constant: 10).isActive = true
        captionLabel.rightAnchor.constraint(equalTo: boxView.rightAnchor, constant: -10).isActive = true
        captionLabel.topAnchor.constraint(equalTo: indicatorView.bottomAnchor, constant: 0).isActive = true
        captionLabel.bottomAnchor.constraint(equalTo: boxView.bottomAnchor, constant: -10).isActive = true
    }
    
    private func setupViews() {
        alpha = 0
        isHidden = true
        backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.4)
        translatesAutoresizingMaskIntoConstraints = false
              
        addSubview(boxView)
        setupBoxView()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
