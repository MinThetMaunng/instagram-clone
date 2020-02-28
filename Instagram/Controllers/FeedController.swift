//
//  FeedController.swift
//  Instagram
//
//  Created by Min Thet Maung on 25/02/2020.
//  Copyright © 2020 Myanmy. All rights reserved.
//

import UIKit

class FeedController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let cellId = "cellId"
    var tableView = UITableView()
    var posts = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setDummyPosts()
    }
    
    fileprivate func setupViews() {
        view.backgroundColor = .white
        navigationItem.title = "Instagram"

//        navigationController?.navigationBar.isTranslucent = false
        
        let arrowButton = UIBarButtonItem(image: UIImage(named: "share"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(goToMessages))
        arrowButton.tintColor = .darkGray
        let cameraButton = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(handleSearch))
        cameraButton.tintColor = .darkGray
        
        navigationItem.leftBarButtonItems = [cameraButton]
        navigationItem.rightBarButtonItems = [arrowButton]
        
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
        tableView.separatorStyle = .none
        tableView.pin(to: view)
        tableView.register(PostCell.self, forCellReuseIdentifier: cellId)
        
    }
    
    @objc private func goToMessages() {
        navigationController?.pushViewController(MessageController(), animated: true)
    }
    
    @objc private func handleSearch() {
        print("search")
    }
    
    private func setDummyPosts() {
        let firstPost = Post(userName: "Juric Daniel", profileImage: "juric_daniel", postImage: "convo", status: "I am Juric Daniel.", createdDate: "3rd Feb 2020")
        let secondPost =  Post(userName: "Juric Daniel", profileImage: "juric_daniel", postImage: "gigi1", status: "I am Juric Daniel. I am currently working as a freelance iOS developer.", createdDate: "3rd Feb 2020")
        
        posts = [ firstPost, secondPost, firstPost, secondPost, firstPost, secondPost, firstPost, secondPost, firstPost, secondPost, firstPost, secondPost, firstPost, secondPost, firstPost, secondPost, firstPost, secondPost, firstPost, secondPost, firstPost, secondPost, firstPost, secondPost, firstPost, secondPost]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! PostCell
        cell.post = posts[indexPath.row]
        return cell
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
    }
   
    
}
