//
//  ProfileController.swift
//  Instagram
//
//  Created by Min Thet Maung on 25/02/2020.
//  Copyright © 2020 Myanmy. All rights reserved.
//

import UIKit

class ProfileController: UIViewController {
    
    let ProfileInfoCellId = "ProfileInfoCellId"
    let FriendProfileInfoCellId = "FriendProfileInfoCellId"
    let PhotoCellId = "PhotoCellId"
    
    var userId: String?
    var user: UserProfileData? {
        didSet {
            if let username = self.user?.user?.username {

                navigationItem.title = username
            }
        }
    }
    var posts: [UserPost]?
    var followStatus: Bool?
    
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
        cv.allowsSelection = false
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
        lbl.text = ""
        lbl.backgroundColor = .clear
        lbl.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        return lbl
    }()

    
    fileprivate func setupNavigation() {
        let logoutButton = UIBarButtonItem(title: "Log Out", style: .plain, target: self, action: #selector(logout))
        navigationItem.rightBarButtonItems = [logoutButton]
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchProfileData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if userId != nil {
            tabBarController?.tabBar.isHidden = true
        } else {
            tabBarController?.tabBar.isHidden = false
        }
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
        UserApiService.instance.getUserProfile(userId: userId ?? AuthService.instance.userId){ (result) in
            
            switch result {
            case .success(let data):
                self.user = data.data
                self.followStatus = data.data?.followStatus
                self.collectionView.reloadData()
            case .failure(let err):
                print(err)
            }
        }
        
        PostApiService.instance.getPostsByUser(userId: userId ?? AuthService.instance.userId, limit: 15, skip: 0) { (result) in
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
        collectionView.register(FriendProfileInfo.self, forCellWithReuseIdentifier: FriendProfileInfoCellId)
        collectionView.register(ProfileInfo.self, forCellWithReuseIdentifier: ProfileInfoCellId)
        collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: PhotoCellId)
        
    }
    
    @objc private func logout(){
//        logoutHud.show()
        AuthService.instance.isLoggedIn = false
        AuthService.instance.jwtToken = ""
        do {
         
//            self.logoutHud.hide()
            try self.dismiss(animated: true){
            }
        } catch(let err) {
            print("ERROR LOGGING OUT")
            print(err.localizedDescription)
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
    
    @objc private func handleMessage() {
        guard let userId = self.userId else { return }
    
        SocketService.instance.createChatbox(user2: userId) { (result) in
            switch result {
            case .success(let data):
                let chatboxController = ChatBoxController()
                
                chatboxController.chatbox = data
                chatboxController.friend = data.user1
                if data.user1?._id == AuthService.instance.userId {
                    chatboxController.friend = data.user2
                }
                
                self.navigationController?.pushViewController(chatboxController, animated: true)
            case .failure(let err):
                print("err")
                print(err.localizedDescription)
            }
        }
        return

    }
    
    @objc private func handleFollow() {
        
        if let userId = self.userId {

            FollowApiService.instance.followOrUnfollowAUser(by: AuthService.instance.userId, to: userId) { (result) in
                switch result {
                case .success(let result):

                    let indexPath = IndexPath(item: 0, section: 0)
                    
                    switch result.status {
                    case 201:
                        (self.collectionView.cellForItem(at: indexPath) as! FriendProfileInfo).setStatus(status: true)
                        
                    case 200:
                        (self.collectionView.cellForItem(at: indexPath) as! FriendProfileInfo).setStatus(status: false)
                    default:
                        print("Error")
                    }

                case .failure(let err):
                    print("Error in handle follow or unfollow request - response /")
                    print(err.localizedDescription)
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.section == 0 {
            if let followStatus = self.followStatus {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FriendProfileInfoCellId, for: indexPath) as! FriendProfileInfo
                
                cell.profile = user
                cell.setStatus(status: followStatus)
                cell.followButton.addTarget(self, action: #selector(handleFollow), for: .touchUpInside)
                cell.messageButton.addTarget(self, action: #selector(handleMessage), for: .touchUpInside)
                return cell
            }
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfileInfoCellId, for: indexPath) as! ProfileInfo
            cell.profile = self.user
            return cell
        }

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCellId, for: indexPath) as! PhotoCell
        cell.photoView.image = UIImage(named: "gray")
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
