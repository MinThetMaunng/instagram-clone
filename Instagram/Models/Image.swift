//
//  Image.swift
//  Instagram
//
//  Created by Min Thet Maung on 12/03/2020.
//  Copyright © 2020 Myanmy. All rights reserved.
//

import UIKit

struct Image {
    let key: String
    let fileName: String
    let data: Data
    let mimeType: String
    
    init?(withImage image: UIImage, forKey key: String) {
        self.key = key
        self.mimeType = "image/jpeg"
        self.fileName = "\(UUID().uuidString).jpg"
        
        guard let data = image.jpegData(compressionQuality: 1) else { return nil }
        self.data = data
    }
}
