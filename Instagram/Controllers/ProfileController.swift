//
//  ProfileController.swift
//  Instagram
//
//  Created by Min Thet Maung on 25/02/2020.
//  Copyright © 2020 Myanmy. All rights reserved.
//

import UIKit

class ProfileController: UIViewController {
    
    let cellId = "cellId"
    let tableView = UITableView()
//    let collectionView = UICollectionView()
    
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

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        navigationItem.titleView = titleView
        let logoutButton = UIBarButtonItem(title: "Log Out", style: .plain, target: self, action: #selector(logout))
        navigationItem.rightBarButtonItems = [logoutButton]
        
        setupTableView()
        setupViews()
    }
    
    @objc private func logout(){
        logoutHud.show()
        AuthService.instance.isLoggedIn = false
        AuthService.instance.jwtToken = ""
        dismiss(animated: true){
            self.logoutHud.hide()
        }
    }
    
    fileprivate func setupViews() {
        view.addSubview(tableView)
        view.addSubview(logoutHud)
        
        logoutHud.pin(to: view)
        
        tableView.pin(to: view)
    }
    
    fileprivate func setupTableView() {
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ProfileInfo.self, forCellReuseIdentifier: cellId)
        tableView.estimatedRowHeight = 234.667
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    

}


extension ProfileController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ProfileInfo
        return cell
    }
    
    
}
