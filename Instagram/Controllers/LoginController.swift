//
//  LoginController.swift
//  Instagram
//
//  Created by Min Thet Maung on 25/02/2020.
//  Copyright © 2020 Myanmy. All rights reserved.
//

import UIKit

class LoginController: UIViewController {
    
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
    
    lazy var loginButton: CustomButton = {
        let btn = CustomButton(title: "Login")
        btn.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        return btn
    }()
    
    let goToRegisterButton: UIButton = {
        let btn = UIButton(type: .system)
        
        let attributedString = NSMutableAttributedString(string: "No account yet? ", attributes: [NSAttributedString.Key.foregroundColor : UIColor.gray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .regular)])
        
        attributedString.append(NSAttributedString(string: "Sign Up here!", attributes: [NSAttributedString.Key.foregroundColor : #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1), NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .regular)]))

        btn.setAttributedTitle(attributedString, for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(goToRegisterScreen), for: .touchUpInside)
        return btn
    }()
    
    @objc private func goToRegisterScreen() {
        let registerController = RegisterController()
        navigationController?.pushViewController(registerController, animated: true)
    }
    
    @objc private func handleLogin() {
        let emailText = emailTextField.text
        let passwordText = passwordTextField.text
        
        emailText == "" ? emailTextField.showErrorMessage() : emailTextField.hideErrorMessage()
        passwordText == "" ? passwordTextField.showErrorMessage() : passwordTextField.hideErrorMessage()
        let homeController = HomeController()
        navigationController?.pushViewController(homeController, animated: true)
    }
    
    lazy var stackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [self.emailTextField, self.passwordTextField, self.loginButton])
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
        view.backgroundColor = .white
        view.addSubview(stackView)
        view.addSubview(goToRegisterButton)
        
        stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50).isActive = true
        stackView.heightAnchor.constraint(equalToConstant: 190).isActive = true
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        loginButton.widthAnchor.constraint(equalTo: stackView.widthAnchor).isActive = true
        loginButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        goToRegisterButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50).isActive = true
        goToRegisterButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50).isActive = true
        goToRegisterButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        goToRegisterButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
        
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


