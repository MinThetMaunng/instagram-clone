//
//  RegisterController.swift
//  Instagram
//
//  Created by Min Thet Maung on 25/02/2020.
//  Copyright © 2020 Myanmy. All rights reserved.
//

import UIKit

class RegisterController: UIViewController {
    
    
    let firstNameTextField: InputText = {
        let tf = InputText(padding: 24, height: 50, placeholder: "First Name")
        tf.autocapitalizationType = .words
        tf.addTarget(self, action: #selector(run(sender:)), for: .editingChanged)
        return tf
    }()
    
    let lastNameTextField: InputText = {
        let tf = InputText(padding: 24, height: 50, placeholder: "Last Name")
        tf.autocapitalizationType = .words
        tf.addTarget(self, action: #selector(run(sender:)), for: .editingChanged)
        return tf
    }()
    
    let emailTextField: InputText = {
        let tf = InputText(padding: 24, height: 50, placeholder: "Email")
        tf.keyboardType = .emailAddress
        tf.addTarget(self, action: #selector(run(sender:)), for: .editingChanged)
        return tf
    }()
    
    @objc private func run(sender: InputText) {
        let text = sender.text
        sender.alpha = text == "" ? 0.4 : 1
    }
    
    let passwordTextField: InputText = {
        let tf = InputText(padding: 24, height: 50, placeholder: "Password")
        tf.isSecureTextEntry = true
        tf.addTarget(self, action: #selector(run(sender:)), for: .editingChanged)
        return tf
    }()
    
    
    let gradientLayer = CAGradientLayer()

    lazy var loginButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("SIGN UP", for: .normal)
        btn.setTitleColor(primaryColor, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        btn.layer.cornerRadius = 25
        btn.layer.masksToBounds = true
        btn.backgroundColor = .white
        btn.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        return btn
    }()
    
    let goToLoginButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Already registered? Log in here!", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .ultraLight)
        btn.setTitleColor(UIColor(white: 1, alpha: 0.6), for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(goToLoginScreen), for: .touchUpInside)
        return btn
    }()
    
    @objc private func goToLoginScreen() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func handleLogin() {
        let emailText = emailTextField.text
        let passwordText = passwordTextField.text
        
        emailText == "" ? emailTextField.showErrorMessage() : emailTextField.hideErrorMessage()
        passwordText == "" ? passwordTextField.showErrorMessage() : passwordTextField.hideErrorMessage()
    }
    
    lazy var stackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [self.firstNameTextField, self.lastNameTextField, self.emailTextField, self.passwordTextField, self.loginButton])
        sv.distribution = .equalSpacing
        sv.spacing = 30
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
    
    
    override func viewWillLayoutSubviews() {
        view.addGradientLayer(locations: [0, 1], colors: primaryColor.cgColor, secondaryColor.cgColor)
    }
    
    private func setupViews() {
        navigationController?.isNavigationBarHidden = true
        view.addSubview(stackView)
        view.addSubview(goToLoginButton)
        
        stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50).isActive = true
        stackView.heightAnchor.constraint(equalToConstant: 370).isActive = true
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        loginButton.widthAnchor.constraint(equalTo: stackView.widthAnchor).isActive = true
        loginButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
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


