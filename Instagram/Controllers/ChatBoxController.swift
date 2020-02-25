//
//  ChatBoxController.swift
//  Instagram
//
//  Created by Min Thet Maung on 25/02/2020.
//  Copyright © 2020 Myanmy. All rights reserved.
//

import UIKit

class ChatBoxController: UIViewController {

    var chatbox: ChatBox?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    let titleView: UILabel = {
        let lbl = UILabel(frame: CGRect(x: 0, y: 0, width: 140, height: 40))
        lbl.text = "asdadasd"
        lbl.textColor = .black
        lbl.textAlignment = .center
        lbl.backgroundColor = .clear
        return lbl
    }()
    
    let bottomStackView: UIStackView = {
        let sv = UIStackView()
        return sv
    }()
    
    private func setupViews() {
        view.backgroundColor = .white
        titleView.text = chatbox?.chatUserName
        navigationItem.titleView = titleView
        tabBarController?.tabBar.isHidden = true
    }


}
