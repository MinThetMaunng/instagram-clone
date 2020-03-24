//
//  ProfileController.swift
//  Instagram
//
//  Created by Min Thet Maung on 25/02/2020.
//  Copyright © 2020 Myanmy. All rights reserved.
//

import UIKit

class ProfileController: UIViewController {
    
    
    let ProfileInfoCellId = "ProfileInfo"
    let PhotoCellId = "PhotoCellId"
    var multiplier = 0
    var user: UserProfileData?
    var posts: [UserPost]?
    
    let refreshControl: UIRefreshControl = {
        let rc = UIRefreshControl()
        rc.addTarget(self, action: #selector(fetchProfileData), for: .valueChanged)
        return rc
    }()
    
    @objc private func refreshScreen() {
        print("Refreshing")
    }
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 0
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        cv.refreshControl = self.refreshControl
        return cv
    }()
    
    let logoutHud: ModalBox = {
        let mb = ModalBox()
        mb.captionLabel.text = "LOGGING OUT"
        return mb
    }()

    lazy var titleView: UILabel = {
        let lbl = UILabel()
        lbl.frame = CGRect(x: self.view.frame.width - 30, y: 10, width: 180, height: 40)
        lbl.textAlignment = .center
        lbl.textColor = .black
        lbl.text = "juric_daniel"
        lbl.backgroundColor = .clear
        lbl.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        return lbl
    }()

    
    fileprivate func setupNavigation() {
        navigationItem.titleView = titleView
        let logoutButton = UIBarButtonItem(title: "Log Out", style: .plain, target: self, action: #selector(logout))
        navigationItem.rightBarButtonItems = [logoutButton]
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchProfileData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigation()
        setupCollectionView()
        setupViews()
        fetchProfileData()
    }
    
    @objc fileprivate func fetchProfileData() {
        self.refreshControl.beginRefreshing()
        self.multiplier = 0
        UserApiService.instance.getUserProfile { (result) in
            
            switch result {
            case .success(let data):
                self.user = data.data
                self.collectionView.reloadData()
            case .failure(let err):
                print(err)
            }
        }
        
        PostApiService.instance.getPostsByUser(userId: AuthService.instance.userId, limit: 15, skip: 0) { (result) in
            switch result {
            case .success(let data):
                self.posts = data.data
                self.refreshControl.endRefreshing()
                self.collectionView.reloadData()
            case .failure(let err):
                print(err)
                self.refreshControl.endRefreshing()
            }
        }
        
    }
    
    fileprivate func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ProfileInfo.self, forCellWithReuseIdentifier: ProfileInfoCellId)
        collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: PhotoCellId)
        
    }
    
    @objc private func logout(){
        logoutHud.show()
        AuthService.instance.isLoggedIn = false
        AuthService.instance.jwtToken = ""

        self.logoutHud.hide()
        dismiss(animated: true){
        }
    }
    
    fileprivate func setupViews() {
        view.backgroundColor = .white
        view.addSubview(collectionView)
        view.addSubview(logoutHud)
        
        logoutHud.pin(to: view)
        collectionView.pin(to: view)
    }
    

}



extension ProfileController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        let total = self.posts?.count ?? 0
        if total == 0 {
            return 1
        }
        return Int(ceil(Double(Float(total) / 3))) + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        let total = self.posts?.count ?? 0
        let noOfItems = total - (section * 3)
        if noOfItems > 0 {
            return 3
        }
        return 3 + noOfItems
    }
    
   
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfileInfoCellId, for: indexPath) as! ProfileInfo
            cell.profile = user
            return cell
        }

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCellId, for: indexPath) as! PhotoCell
        cell.photoView.image = nil
        cell.data = self.posts?[calculateIndexOfArray(indexPath: indexPath)]
        return cell
        
    }
    
    private func calculateIndexOfArray(indexPath: IndexPath) -> Int {
        return ( (indexPath.section - 1) * 3) + indexPath.item
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let viewWidth = view.frame.size.width
        if indexPath.section == 0 {
            return CGSize(width: viewWidth, height: 236.3)
        }
        return CGSize(width: (viewWidth / 3) - 0.5, height: (viewWidth / 3))
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
       
       
}
