//
//  RegisterController.swift
//  Instagram
//
//  Created by Min Thet Maung on 25/02/2020.
//  Copyright © 2020 Myanmy. All rights reserved.
//

import UIKit

extension RegisterController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.editedImage] as? UIImage {
            profileImage.setImage(image, for: .normal)
            chosenImage = image
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

class RegisterController: UIViewController {
    
    var chosenImage: UIImage?
    
    lazy var registerHud: ModalBox = {
        let mb = ModalBox()
        mb.captionLabel.text = "SIGNNING UP"
        return mb
    }()
    
    let profileImage: UIButton = {
        let btn = UIButton()
        btn.layer.cornerRadius = 75
        btn.layer.borderColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        btn.layer.borderWidth = 3
        btn.clipsToBounds = true
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.titleLabel?.numberOfLines = 1
        btn.titleLabel?.textAlignment = .center
        btn.imageView?.contentMode = .scaleAspectFill
        let attributedString = NSMutableAttributedString(string: "+", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 80, weight: .thin), NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)])
        btn.setAttributedTitle(attributedString, for: .normal)
        
        btn.addTarget(self, action: #selector(chooseProfileImage), for: .touchUpInside)
        return btn
    }()
    
    @objc private func chooseProfileImage() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        imagePicker.modalPresentationStyle = .overFullScreen
        present(imagePicker, animated: true, completion: nil)
    }
    
    let userNameTextField: InputText = {
        let tf = InputText(padding: 24, height: 50, placeholder: "Username")
        tf.autocapitalizationType = .none
        return tf
    }()
    
    let emailTextField: InputText = {
        let tf = InputText(padding: 24, height: 50, placeholder: "Email")
        tf.keyboardType = .emailAddress
        return tf
    }()
    
    let passwordTextField: InputText = {
        let tf = InputText(padding: 24, height: 50, placeholder: "Password")
        tf.isSecureTextEntry = true
        return tf
    }()
    
    lazy var signupButton: CustomButton = {
        let btn = CustomButton(title: "Sign Up")
        btn.addTarget(self, action: #selector(handleSignup), for: .touchUpInside)
        return btn
    }()
    
    let goToLoginButton: UIButton = {
        let btn = UIButton(type: .system)
        let attributedString = NSMutableAttributedString(attributedString: NSAttributedString(string: "Already registered? ", attributes: [NSAttributedString.Key.foregroundColor : UIColor.gray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .regular)]))
        attributedString.append(NSAttributedString(string: "Log in here!", attributes: [NSAttributedString.Key.foregroundColor : #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1), NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .semibold)] ))
        btn.setAttributedTitle(attributedString, for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(goToLoginScreen), for: .touchUpInside)
        return btn
    }()
    
    @objc private func goToLoginScreen() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func handleSignup() {
        let userNameText = userNameTextField.text ?? ""
        let emailText = emailTextField.text ?? ""
        let passwordText = passwordTextField.text ?? ""
        
        userNameText == "" ? userNameTextField.showErrorMessage() : userNameTextField.hideErrorMessage()
        emailText == "" ? emailTextField.showErrorMessage() : emailTextField.hideErrorMessage()
        passwordText == "" ? passwordTextField.showErrorMessage() : passwordTextField.hideErrorMessage()
        
        self.registerHud.show()
        guard let profileImage = chosenImage else {
            self.registerHud.hide()
            return
        }
        
        if userNameText != "", emailText != "", passwordText != ""{
            let body: Parameters = ["username": userNameText, "email": emailText, "password": passwordText]
            UserApiService.instance.signupRequest(parameters: body, image: profileImage) { (result) in
                switch result {
                case .success(let response):
                    switch response.status {
                    case 201:
                        self.registerHud.hide()
                        let homeController = HomeController()
                        homeController.modalPresentationStyle = .overFullScreen
                        self.present(homeController, animated: true, completion: nil)
                        
                    default:
                        self.registerHud.hide()
                    }
                case .failure(let error):
                    print("Error")
                    print(error)
                    
                }
            }
        }
    }
    
    lazy var stackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [self.userNameTextField, self.emailTextField, self.passwordTextField, self.signupButton])
        sv.distribution = .equalSpacing
        sv.spacing = 20
        sv.axis = .vertical
        sv.backgroundColor = .white
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
        setupNotificationObservers()
        setupTapGesture()
    }
    
    private func setupViews() {
        navigationController?.isNavigationBarHidden = true
        view.addSubview(profileImage)
        view.addSubview(stackView)
        view.addSubview(goToLoginButton)
        
        
        view.addSubview(registerHud)
        registerHud.add(to: view)
        
        stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50).isActive = true
        stackView.heightAnchor.constraint(equalToConstant: 260).isActive = true
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        signupButton.widthAnchor.constraint(equalTo: stackView.widthAnchor).isActive = true
        signupButton.heightAnchor.constraint(equalToConstant: 50).isActive = true

        profileImage.widthAnchor.constraint(equalToConstant: 150).isActive = true
        profileImage.heightAnchor.constraint(equalToConstant: 150).isActive = true
        profileImage.bottomAnchor.constraint(equalTo: stackView.topAnchor, constant: -30).isActive = true
        profileImage.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true

        goToLoginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50).isActive = true
        goToLoginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50).isActive = true
        goToLoginButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        goToLoginButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
        
    }
    
    fileprivate func setupTapGesture() {
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapDismiss)))
    }
    
    @objc fileprivate func handleTapDismiss() {
        self.view.endEditing(true)
    }
    
    fileprivate func setupNotificationObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc fileprivate func handleKeyboardShow(notification: Notification) {
        guard let value = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardFrame = value.cgRectValue
        let bottomSpace = view.frame.height - stackView.frame.origin.y - stackView.frame.height
        let difference = keyboardFrame.height - bottomSpace
        self.view.transform = CGAffineTransform(translationX: 0, y: -difference - 8)
    }
    
    @objc fileprivate func handleKeyboardHide() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.transform = .identity
        })
    }

}


