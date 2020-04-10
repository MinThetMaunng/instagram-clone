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
    
    let refreshControl: UIRefreshControl = {
        let rc = UIRefreshControl()
        rc.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        return rc
    }()
    
    @objc private func refreshData() {
    }
    
    
    @objc private func fetchChatboxes() {
        tableView.refreshControl?.beginRefreshing()
        SocketService.instance.fetchChatboxes { (result) in
            switch result {
            case .success(let data):
                self.chatBoxes = data
                self.tableView.reloadData()
            case .failure(let err):
                print("Error : \(err.localizedDescription)")
            }
            self.tableView.refreshControl?.endRefreshing()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        fetchChatboxes()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        title = "Chat"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(handleBack))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(handleCompose))
        view.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 92
        tableView.separatorStyle = .none
        
        tableView.pin(to: view)
        tableView.refreshControl = refreshControl
        tableView.register(ChatBoxCell.self, forCellReuseIdentifier: cellId)
    }
    
    @objc private func handleCompose() {
        
    }
    
    @objc private func handleBack() {
        
        navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatBoxes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ChatBoxCell
        
        cell.friend = chatBoxes[indexPath.row].user1
        if chatBoxes[indexPath.row].user1?._id == AuthService.instance.userId {
            cell.friend = chatBoxes[indexPath.row].user2
        }
        cell.chatbox = chatBoxes[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chatbox = chatBoxes[indexPath.row]
        let chatboxController = ChatBoxController()
        chatboxController.chatbox = chatbox
        
        chatboxController.friend = chatBoxes[indexPath.row].user1
        if chatBoxes[indexPath.row].user1?._id == AuthService.instance.userId {
            chatboxController.friend = chatBoxes[indexPath.row].user2
        }
        navigationController?.pushViewController(chatboxController, animated: true)
    }
    
}
