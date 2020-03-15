//
//  ApiService.swift
//  Instagram
//
//  Created by Min Thet Maung on 05/03/2020.
//  Copyright © 2020 Myanmy. All rights reserved.
//

import UIKit

class ApiService {
    static let instance = ApiService()
    
    func createDataBody(withParameters parameters: Parameters?, medias: [Image]?, boundary: String) -> Data {
        let lineBreak = "\r\n"
        var body = Data()
        
        if let params = parameters {
            for (key, value) in params {
                body.append("--\(boundary + lineBreak)")
                body.append("Content-Disposition: form-data; name=\"\(key)\"\(lineBreak + lineBreak)")
                body.append("\(value + lineBreak)")
            }
        }
        
        if let medias = medias {
            for media in medias {
                body.append("--\(boundary + lineBreak)")
                body.append("Content-Disposition: form-data; name=\"\(media.key)\"; filename=\"\(media.fileName)\"\(lineBreak)")
                body.append("Content-Type: \(media.mimeType + lineBreak + lineBreak)")
                body.append(media.data)
                body.append(lineBreak)
            }
        }
        
        body.append("--\(boundary)--\(lineBreak)")
        return body
    }
    
    func generateBoundary() -> String {
        return "Boundary-\(UUID().uuidString)"
    }
}

extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}
