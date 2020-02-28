//
//  SearchController.swift
//  Instagram
//
//  Created by Min Thet Maung on 28/02/2020.
//  Copyright © 2020 Myanmy. All rights reserved.
//

import UIKit

class SearchController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    lazy var imagePicker: UIImagePickerController = {
        let ip = UIImagePickerController()
        
        ip.delegate = self
        ip.allowsEditing = true
        ip.sourceType = .photoLibrary
        ip.modalPresentationStyle = .currentContext
        return ip
    }()
    
    override func viewDidLoad() {
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.present(imagePicker, animated: false, completion: nil)
    }
    
    override func viewWillLayoutSubviews() {
    }
}
