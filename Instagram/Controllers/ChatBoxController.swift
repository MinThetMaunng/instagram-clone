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
    let CellId = "CellId"
    var collectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
//        layout.minimumInteritemSpacing = 10
//        layout.minimumLineSpacing = 10
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        cv.allowsSelection = false
        cv.alwaysBounceVertical = true
        return cv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupNotificationObservers()
        setupTapGesture()
    }
    
    let titleView: UILabel = {
        let lbl = UILabel(frame: CGRect(x: 0, y: 0, width: 140, height: 40))
        lbl.textColor = .black
        lbl.textAlignment = .center
        lbl.backgroundColor = .clear
        return lbl
    }()
    
    let micButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(named: "mic"), for: .normal)
        btn.layer.cornerRadius = 36 / 2
        btn.clipsToBounds = true
        btn.backgroundColor = .white
        btn.tintColor = .black
        return btn
    }()
    
    let galleryButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(named: "gallery"), for: .normal)
        btn.layer.cornerRadius = 36 / 2
        btn.clipsToBounds = true
        btn.backgroundColor = .white
        btn.tintColor = .black
        return btn
    }()
    
    let cameraButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(named: "camera"), for: .normal)
        btn.layer.cornerRadius = 36 / 2
        btn.clipsToBounds = true
        btn.backgroundColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
        btn.tintColor = .white
        return btn
    }()
    
    let textBox: UITextField = {
        let tf = UITextField()
        tf.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        tf.backgroundColor = .clear
        tf.placeholder = "Message..."
        tf.addTarget(self, action: #selector(handleTyping(sender:)), for: .editingChanged)
        return tf
    }()
    
    lazy var sendButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Send", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        btn.tintColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        btn.backgroundColor = .clear
        btn.layer.cornerRadius = 20
        btn.frame = CGRect(x: self.view.frame.width - 100, y: 2.5, width: 73, height: 40)
        btn.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
        return btn
    }()

    
    let bottomRoundView: UIView = {
        let v = UIView()
        v.layer.cornerRadius = 22.5
        v.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        v.layer.borderWidth = 1
        v.backgroundColor = .white
        return v
    }()

    
    let bottomBackgroundView: UIView = {
        let v = UIView()
        v.backgroundColor = .white
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    @objc private func handleTyping(sender: UITextField) {
        
        let iconBtnScale: CGFloat = sender.text != "" ? 0.0 : 1.0
        let sendBtnScale: CGFloat = sender.text != "" ? 1.0 : 0.0
        
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 4, options: .curveEaseOut, animations: {
            self.micButton.transform = CGAffineTransform(scaleX: iconBtnScale, y: iconBtnScale)
            self.galleryButton.transform = CGAffineTransform(scaleX: iconBtnScale, y: iconBtnScale)
            self.sendButton.transform = CGAffineTransform(scaleX: sendBtnScale, y: sendBtnScale)
            self.view.layoutIfNeeded()
        }) { (complete) in
        }
            
    }
    
    fileprivate func setupBottomBackgroundViewConstraints() {
        view.addSubview(self.bottomBackgroundView)
        view.addSubview(self.collectionView)

        view.constraintWithVisualFormat(format: "H:|[v0]|", views: self.collectionView)
        view.constraintWithVisualFormat(format: "H:|[v0]|", views: self.bottomBackgroundView)
     
        NSLayoutConstraint.activate([
            self.bottomBackgroundView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 15),
            self.bottomBackgroundView.heightAnchor.constraint(equalToConstant: 60),
            
            self.collectionView.bottomAnchor.constraint(equalTo: self.bottomBackgroundView.topAnchor),
            self.collectionView.topAnchor.constraint(equalTo: self.view.topAnchor)
        ])
        
    }
    
    fileprivate func setupBottomRoundSubViews() {
        self.bottomRoundView.addSubview(self.cameraButton)
        self.bottomRoundView.addSubview(self.textBox)
        self.bottomRoundView.addSubview(self.micButton)
        self.bottomRoundView.addSubview(self.galleryButton)
        self.bottomRoundView.addSubview(self.sendButton)
        
        self.bottomRoundView.constraintWithVisualFormat(format: "H:|-4.5-[v0(36)]-4.5-[v1]-1-[v2(36)]-1-[v3(36)]-10-|", views: self.cameraButton, self.textBox, self.micButton, self.galleryButton )
        
        self.bottomRoundView.constraintWithVisualFormat(format: "V:|-4.5-[v0(36)]-4.5-|", views: self.cameraButton)
        self.bottomRoundView.constraintWithVisualFormat(format: "V:|-4.5-[v0(36)]-4.5-|", views: self.textBox)
        self.bottomRoundView.constraintWithVisualFormat(format: "V:|-4.5-[v0(36)]-4.5-|", views: self.micButton)
        self.bottomRoundView.constraintWithVisualFormat(format: "V:|-4.5-[v0(36)]-4.5-|", views: self.galleryButton)
    }
    
    fileprivate func setupBottomBackgroundSubViews() {
        self.bottomBackgroundView.addSubview(self.bottomRoundView)
        
        self.bottomBackgroundView.constraintWithVisualFormat(format: "H:|-10-[v0]-10-|", views: self.bottomRoundView)
        self.bottomBackgroundView.constraintWithVisualFormat(format: "V:|-5-[v0(45)]-10-|", views: self.bottomRoundView)
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        titleView.text = chatbox?.user1?.username
        navigationItem.titleView = titleView
        navigationController?.view.backgroundColor = .white
        tabBarController?.tabBar.isHidden = true
        
        setupBottomRoundSubViews()
        setupBottomBackgroundSubViews()
        setupBottomBackgroundViewConstraints()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: CellId)
        
    }
    
    
    fileprivate func setupTapGesture() {
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapDismiss)))
    }
    
    @objc fileprivate func handleTapDismiss() {
        self.bottomRoundView.endEditing(true)
    }
    
    fileprivate func setupNotificationObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleForeground), name: NOTI_BACK_TO_FOREGROUND, object: nil)
    }
    
    
    
    @objc func handleForeground() {
        handleTapDismiss()
        handleKeyboardHide()
        view.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
    }
    
    @objc fileprivate func handleKeyboardShow(notification: Notification) {
        guard let value = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardFrame = value.cgRectValue
        let bottomSpace = view.frame.height - bottomBackgroundView.frame.origin.y - bottomBackgroundView.frame.height
        let difference = keyboardFrame.height - bottomSpace

        self.view.transform = CGAffineTransform(translationX: 0, y: -difference)
    }
    
    @objc fileprivate func handleKeyboardHide() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.transform = .identity
        })
    }

}


extension ChatBoxController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellId, for: indexPath) as! UICollectionViewCell
//        cell.backgroundColor = .systemBlue
        return cell
    }
    
    
}
