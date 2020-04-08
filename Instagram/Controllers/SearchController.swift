//
//  SearchController.swift
//  Instagram
//
//  Created by Min Thet Maung on 28/02/2020.
//  Copyright © 2020 Myanmy. All rights reserved.
//

import UIKit


class SearchController: UIViewController {
    
    let cellId = "cellId"
    var users: [User]?
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 1
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    let refreshControl: UIRefreshControl = {
        let rc = UIRefreshControl()
        rc.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        return rc
    }()
    
    lazy var searchBar: UISearchBar = {
        let sb = UISearchBar(frame: .zero)
        sb.delegate = self
        sb.returnKeyType = .search
        sb.showsCancelButton = true
        sb.placeholder = "Search"
        return sb
    }()
    
    @objc fileprivate func handleRefresh() {
        
    }
    
    fileprivate func setupNavigationBar() {
        navigationItem.titleView = self.searchBar
    }
    
    fileprivate func setupDelegatesAndDataSource() {
        collectionView.refreshControl = refreshControl
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UserCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    fileprivate func setupViews() {
        view.addSubview(collectionView)
        collectionView.pin(to: view)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupDelegatesAndDataSource()
        setupViews()
        fetchData()
    }
    
    private func fetchData() {
        
    }

}


extension SearchController: UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        self.users = []
        self.collectionView.reloadData()
        self.navigationController?.navigationBar.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            self.users = []
            self.collectionView.reloadData()
            return
        }
        self.collectionView.refreshControl?.beginRefreshing()
        UserApiService.instance.getUsers(limit: 12, skip: 0, username: searchText) { (result) in
            switch result {
            case .success(let data):
                self.users = data.data
                self.collectionView.refreshControl?.endRefreshing()
                self.collectionView.reloadData()
            case .failure(let err):
                print("Error")
                print(err.localizedDescription)
            }
        }
    }
    
}

extension SearchController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return users?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! UserCell
        cell.profileImage.image = UIImage(named: "gray")
        cell.userData = self.users?[indexPath.section]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let profileViewController = ProfileController()
        if self.users?[indexPath.section]._id == AuthService.instance.userId {
            tabBarController?.selectedIndex = 4
            return
        }
        profileViewController.userId = self.users?[indexPath.section]._id
        profileViewController.modalPresentationStyle = .fullScreen
        profileViewController.tabBarController?.tabBar.isHidden = true
        navigationController?.pushViewController(profileViewController, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.size.width, height: 82)
    }
    
}
