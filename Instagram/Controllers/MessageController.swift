//
//  MessageController.swift
//  Instagram
//
//  Created by Min Thet Maung on 25/02/2020.
//  Copyright © 2020 Myanmy. All rights reserved.
//

import UIKit

class MessageController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let cellId = "cellId"
    let tableView = UITableView()
    var chatBoxes = [ChatBox]()
    
    private func addDummyChatBox() {
        let markZuckerberg = ChatBox(id: nil, lastMin: "3 mins", chatUserName: "Mark Zuckerberg", chatUserImage: "mark_zuckerberg", lastMessage: "Hey! I need your advice for new feature for instagram.")
        let juricDaniel = ChatBox(id: nil, lastMin: "26 mins", chatUserName: "Juric Daniel", chatUserImage: "juric_daniel", lastMessage: "I am the boss here. You know what i mean?")
        let poeMamheThar = ChatBox(id: nil, lastMin: "7 mins", chatUserName: "Jeff Bezos", chatUserImage: "jeff", lastMessage: "Please contact me ASAP.")
        let nanPhooPhooMon = ChatBox(id: nil, lastMin: "57 mins", chatUserName: "Sergey Brin", chatUserImage: "sergey", lastMessage: "Sergey sent a photo.")
        let benedictCumberbatch = ChatBox(id: nil, lastMin: "Active Now", chatUserName: "Benedict Cumberbatch", chatUserImage: "benedict_cumberbatch", lastMessage: "I am going to win Oscar tonight? Have you heard already?")
        let khinYatiThin = ChatBox(id: nil, lastMin: "26 mins", chatUserName: "Bill Gates", chatUserImage: "bill", lastMessage: "Bill reacted your message.")
        let honeyNwayOo = ChatBox(id: nil, lastMin: "Active Now", chatUserName: "Elon Musk", chatUserImage: "elon", lastMessage: "We're going to Mars next year.")
        chatBoxes = [ markZuckerberg, juricDaniel, poeMamheThar, nanPhooPhooMon, benedictCumberbatch, khinYatiThin, honeyNwayOo, markZuckerberg, juricDaniel, poeMamheThar, nanPhooPhooMon, benedictCumberbatch, khinYatiThin, honeyNwayOo ]
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        view.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 92
        addDummyChatBox()
        tableView.pin(to: view)
        
        tableView.register(ChatBoxCell.self, forCellReuseIdentifier: cellId)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatBoxes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ChatBoxCell
        cell.chatBox = chatBoxes[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chatbox = chatBoxes[indexPath.row]
        let chatboxController = ChatBoxController()
        chatboxController.chatbox = chatbox
        navigationController?.pushViewController(chatboxController, animated: true)
    }
    
}
