//
//  ChatBoxController.swift
//  Instagram
//
//  Created by Min Thet Maung on 25/02/2020.
//  Copyright © 2020 Myanmy. All rights reserved.
//

import UIKit

class ChatBoxController: UIViewController {
    
    var friend: User? {
        didSet {
            titleLabel.text = friend?.username
            if let imageUrl = friend?.profileImage {
                
                profileImage.loadImageUsingUrl(string: "\(PROFILE_IMAGE_URL)\(imageUrl)")
            }
        }
    }

    var chatbox: ChatBox?
    var messages = [Message]()

    let CellId = "CellId"
    
    var viewBottomAnchor: NSLayoutConstraint?
    var bottomBackgroundViewBottomAnchor: NSLayoutConstraint?
    
    var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        cv.allowsSelection = false
        cv.alwaysBounceVertical = true
        return cv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        fetchMessages()
        setupNotificationObservers()
        setupTapGesture()
        listenNewMessage()
    }
    
    private func fetchMessages() {
        guard let chatboxId = chatbox?._id else { return }
        collectionView.refreshControl?.beginRefreshing()
        
        SocketService.instance.fetchMessages(chatbox: chatboxId) { (result) in
            switch result {
            case .success(let data):
                self.messages = data
                self.collectionView.refreshControl?.endRefreshing()
                self.collectionView.reloadData()
                self.collectionView.scrollToItem(at: IndexPath(item: 0, section: self.messages.count - 1), at: .top, animated: true)
            case .failure(let err):
                print("Err")
                print(err.localizedDescription)
                self.collectionView.refreshControl?.endRefreshing()
            }
        }
    }
    
    private func listenNewMessage() {
        SocketService.instance.listenNewMessage { (result) in
            switch result {
            case .success(let newMessage):
                self.messages.append(newMessage)
            
                self.collectionView.reloadData()
                  self.collectionView.scrollToItem(at: IndexPath(item: 0, section: self.messages.count - 1), at: .top, animated: true)
            case .failure(let err):
                print("ERR")
                print(err.localizedDescription)
            }
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillLayoutSubviews() {
        view.layoutIfNeeded()
    }
    
    let profileImage: CacheImageView = {
        let iv = CacheImageView()
        iv.contentMode = .scaleAspectFill
        iv.image = UIImage(named: "gray")
        iv.layer.cornerRadius = 15
        iv.layer.masksToBounds = true
        iv.backgroundColor = .darkGray
        return iv 
    }()
    
    let titleView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 1
        lbl.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
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
        btn.addTarget(self, action: #selector(handleSendMessage), for: .touchUpInside)
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
    
    @objc private func handleSendMessage() {
        self.sendButton.isEnabled = false
        if let message = self.textBox.text, message != "",let chatboxId = chatbox?._id {
            SocketService.instance.sendMessage(message: message, chatboxId: chatboxId) { (complete) in
                if complete {
                    self.textBox.text = ""
                    self.sendButton.isEnabled = true
                } else {
                    print("Not Completed")
                    self.sendButton.isEnabled = true
                }
                self.handleTyping(sender: self.textBox)
            }
        }
    }
    
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
        view.backgroundColor = .white
        view.addSubview(self.bottomBackgroundView)
        view.addSubview(self.collectionView)

        view.constraintWithVisualFormat(format: "H:|[v0]|", views: self.collectionView)
        view.constraintWithVisualFormat(format: "H:|[v0]|", views: self.bottomBackgroundView)
     
        viewBottomAnchor = self.collectionView.bottomAnchor.constraint(equalTo: self.bottomBackgroundView.topAnchor, constant: 0)
//        bottomBackgroundViewBottomAnchor = self.bottomBackgroundView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 15)
        
        NSLayoutConstraint.activate([
            self.bottomBackgroundView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 15),
            self.bottomBackgroundView.heightAnchor.constraint(equalToConstant: 60),
            
            viewBottomAnchor!,
//            self.collectionView.bottomAnchor.constraint(equalTo: self.bottomBackgroundView.topAnchor, constant: 0),
            self.collectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor)
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
       
        titleView.addSubview(profileImage)
        titleView.addSubview(titleLabel)
        
        profileImage.frame = CGRect(x: 0, y: 7, width: 30, height: 30)
        titleLabel.frame = CGRect(x: 38, y: 7, width: 150, height: 30)
        
        titleView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: navigationController?.navigationBar.frame.height ?? 44)
        navigationItem.titleView = titleView
        
        navigationController?.navigationBar.tintColor = .black
        navigationController?.view.backgroundColor = .white
        
        
        tabBarController?.tabBar.isHidden = true
        
        setupBottomRoundSubViews()
        setupBottomBackgroundSubViews()
        setupBottomBackgroundViewConstraints()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(MessageCell.self, forCellWithReuseIdentifier: CellId)
        
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
        
        self.view.frame.size.height = self.view.frame.height - keyboardFrame.height - 15

        self.view.layoutIfNeeded()
        self.collectionView.scrollToItem(at: IndexPath(item: 0, section: self.messages.count - 1), at: .top, animated: true)
    }
    
    @objc fileprivate func handleKeyboardHide() {
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {

            self.view.frame = UIScreen.main.bounds
            
            self.collectionView.scrollToItem(at: IndexPath(item: 0, section: self.messages.count - 1), at: .top, animated: true)
            self.view.transform = .identity
        })
    }

}


extension ChatBoxController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return messages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let estimatedRect = calculateSizeForMessageTextView(text: self.messages[indexPath.section].message)
        return CGSize(width: view.frame.width, height: estimatedRect.height + 20)
        
        
        return CGSize(width: view.frame.width, height: 120)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellId, for: indexPath) as! MessageCell
        let messageText = self.messages[indexPath.section].message
        cell.messageLabel.text = messageText
        let estimatedRect = calculateSizeForMessageTextView(text: messageText)
        
        if self.messages[indexPath.section].sentBy != AuthService.instance.userId {
            
            cell.textBubbleView.backgroundColor = .white
            cell.textBubbleView.layer.borderColor = UIColor(white: 0.95, alpha: 1).cgColor
            cell.textBubbleView.layer.borderWidth = 2
            
            cell.messageLabel.frame = CGRect(x: 32, y: 10, width: estimatedRect.width, height: estimatedRect.height)
            cell.textBubbleView.frame = CGRect(x: 16, y: 0, width: estimatedRect.width + 32, height: estimatedRect.height + 20)
        } else {
            cell.textBubbleView.backgroundColor = UIColor(white: 0.95, alpha: 1)
            cell.textBubbleView.layer.borderColor = UIColor(white: 0.95, alpha: 1).cgColor
            cell.textBubbleView.layer.borderWidth = 2
            
            cell.messageLabel.frame = CGRect(x: view.frame.width - estimatedRect.width - 32, y: 10, width: estimatedRect.width, height: estimatedRect.height)
            cell.textBubbleView.frame = CGRect(x: view.frame.width - estimatedRect.width - 32 - 16, y: 0, width: estimatedRect.width + 32, height: estimatedRect.height + 20)
        }
        
        return cell
    }
    
    
     private func calculateSizeForMessageTextView(text: String) -> CGRect {
        let size = CGSize(width: view.frame.width - 150, height: 4000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        let estimatedSize = NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 20, weight: .regular)], context: nil)
         
         return estimatedSize
     }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}
