//
//  CreatePostController.swift
//  Instagram
//
//  Created by Min Thet Maung on 13/03/2020.
//  Copyright © 2020 Myanmy. All rights reserved.
//

import UIKit

extension CreatePostController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            chosenImage = image
            imagePickerButton.setImage(image, for: .normal)
        }
        dismiss(animated: true, completion: nil)
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
}


class CreatePostController: UIViewController, UITextViewDelegate {
    
    var chosenImage: UIImage?
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = .black
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Write a caption..."
            textView.textColor = .lightGray
        }
    }
    
    let hud: ModalBox = {
        let mb = ModalBox()
        mb.captionLabel.text = "POSTING"
        return mb
    }()
    
    let backgroundView: UIView = {
        let v = UIView()
        v.backgroundColor = .white
        return v
    }()
    
    let imagePickerButton: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = #colorLiteral(red: 0.8675189614, green: 0.8676648736, blue: 0.8674997687, alpha: 1)
        btn.imageView?.contentMode = .scaleAspectFill
        btn.setTitle("+", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 30)
        btn.addTarget(self, action: #selector(choosePhoto), for: .touchUpInside)
        return btn
    }()
    
    @objc private func choosePhoto(){
        self.present(self.imagePicker, animated: true, completion: nil)
    }
    
    
    let textView: UITextView = {
        let tf = UITextView()
        tf.backgroundColor = .clear
        tf.font = UIFont.systemFont(ofSize: 18)
        tf.text = "Write a caption..."
        tf.textColor = .lightGray
        tf.showsVerticalScrollIndicator = false
        return tf
    }()
    
    lazy var imagePicker: UIImagePickerController = {
        let ip = UIImagePickerController()
        ip.modalPresentationStyle = .pageSheet
        ip.delegate = self
        ip.allowsEditing = false
        ip.sourceType = .photoLibrary
        return ip
    }()
    
    fileprivate func setupViews() {
        navigationController?.navigationBar.isHidden = false
        navigationItem.title = "Create Post"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Post", style: .plain, target: self, action: #selector(handlePost))
        
        view.backgroundColor = .red
        view.addSubview(backgroundView)
        backgroundView.addSubview(imagePickerButton)
        backgroundView.addSubview(textView)
        
        view.addSubview(hud)
        hud.add(to: view)
        
        let statusBarHeight = UIApplication.shared.statusBarFrame.height 
        let topAnchorConstant = navigationController?.navigationBar.frame.height ?? 44

        view.constraintWithVisualFormat(format: "H:|[v0]|", views: backgroundView)
        view.constraintWithVisualFormat(format: "V:|-\(topAnchorConstant + statusBarHeight)-[v0(120)]", views: backgroundView)
        
        backgroundView.constraintWithVisualFormat(format: "H:|-16-[v0(80)]-12-[v1]-16-|", views: imagePickerButton, textView)
        backgroundView.constraintWithVisualFormat(format: "V:|-20-[v0(80)]-20-|", views: imagePickerButton)
        backgroundView.constraintWithVisualFormat(format: "V:|-20-[v0(80)]-20-|", views: textView)
    }
    
    @objc private func handlePost(){
        
        if let status = textView.text, let image = chosenImage, textView.textColor == .black {
            let parameters = ["user": AuthService.instance.userId, "status": status]
            hud.show()
            PostApiService.instance.createPostRequest(body: parameters, image: image) { (result) in
                switch result {
                case .success(let response):
                    self.textView.text = nil
                    self.imagePickerButton.setImage(nil, for: .normal)
                    self.tabBarController?.selectedIndex = 4
                    
                case .failure(let error):
                    print(error)
                }
                self.hud.hide()
            }
//            tabBarController?.selectedIndex = 0
//            imagePickerButton.setImage(nil, for: .normal)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.delegate = self
        setupViews()
        setupTapGesture()
    }
    
    fileprivate func setupTapGesture() {
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapDismiss)))
    }
    
    @objc fileprivate func handleTapDismiss() {
        self.view.endEditing(true)
    }
}
