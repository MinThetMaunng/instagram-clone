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
    
    let refreshControl: UIRefreshControl = {
        let rc = UIRefreshControl()
        rc.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        return rc
    }()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.getAllPosts()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupViews()
        getAllPosts()
    }
    
    
    @objc private func refreshData() {
        print("Refreshing")
    }
    
    private func getAllPosts() {
        refreshControl.beginRefreshing()
        PostApiService.instance.getPostsRequest(limit: 0, skip: 0) { (result) in
            switch result {
            case .success(let resp):
                if let data = resp.data {
                    self.posts = data
                    self.tableView.reloadData()
                    self.refreshControl.endRefreshing()
                }
            case .failure(let err):
                print("ERRORS")
                print(err)
            }
        }
    }
    
    
    fileprivate func setupNavigationBar() {
        navigationItem.title = "Instagram"
        
        let arrowButton = UIBarButtonItem(image: UIImage(named: "share"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(goToMessages))
        arrowButton.tintColor = .darkGray
        let cameraButton = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(handleCreatePost))
        cameraButton.tintColor = .darkGray
        
        navigationItem.leftBarButtonItems = [cameraButton]
        navigationItem.rightBarButtonItems = [arrowButton]
    }
    
    fileprivate func setupViews() {
        view.backgroundColor = .white
        
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
        tableView.separatorStyle = .none
        tableView.pin(to: view)
        tableView.register(PostCell.self, forCellReuseIdentifier: cellId)
        
        tableView.refreshControl = refreshControl
        
    }
    
    @objc private func goToMessages() {
        navigationController?.pushViewController(MessageController(), animated: true)
    }
    
    @objc private func handleCreatePost() {
        self.tabBarController?.selectedIndex = 2
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! PostCell
        cell.postImage.image = UIImage(named: "gray")
        cell.post = self.posts[indexPath.row]
        return cell
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
    }
   
    
}
