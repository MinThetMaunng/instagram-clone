//
//  Extensions.swift
//  Instagram
//
//  Created by Min Thet Maung on 25/02/2020.
//  Copyright © 2020 Myanmy. All rights reserved.
//

import UIKit

extension UIColor {
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
}

extension UIView {
    func constraintWithVisualFormat(format: String, views:UIView...) {
        var viewsDict = [String: UIView]()
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            viewsDict[key] = view
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: viewsDict))
    }
    
    func pin(to superView: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        topAnchor.constraint(equalTo: superView.topAnchor).isActive = true
        leadingAnchor.constraint(equalTo: superView.leadingAnchor).isActive = true
        trailingAnchor.constraint(equalTo: superView.trailingAnchor).isActive = true
        bottomAnchor.constraint(equalTo: superView.bottomAnchor).isActive = true
    }
    
    func addGradientLayer(locations: [NSNumber], colors: CGColor...) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        
        gradientLayer.colors = colors
        gradientLayer.locations = locations
        gradientLayer.startPoint = CGPoint(x: 0.3, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.7, y: 1)
        
        layer.insertSublayer(gradientLayer, at: 0)
    }
}

let imageCache = NSCache<NSString, UIImage>()

class CacheImageView: UIImageView {
    
    var imageUrlString: String?
    
    func loadImageUsingUrl(string urlString: String) {
        
        imageUrlString = urlString
        guard let url = URL(string: urlString) else { return }
        
        // if image is already exist in cache
        if let imageFromCache = imageCache.object(forKey: NSString(string: urlString)){
            self.image = imageFromCache

            print("URL________________")
            print(urlString)
            print("Cache")
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print("++++++++++++++++++++++++++++")
                print("Requesting image from server failed: \(String(describing: error))")
                print("++++++++++++++++++++++++++++")
                return
            }
            
//            guard let imageData = data else { return }
            
            DispatchQueue.main.async {
                let imageToCache = UIImage(data: data!)
                if self.imageUrlString == urlString {
                    if imageToCache != nil {

                        print("URL________________")
                        print(urlString)
                        print("Not cache")
                        imageCache.setObject(imageToCache!, forKey: NSString(string: urlString))
                    }
                }
//                if let image = imageCache
                self.image = imageToCache
            }
        }.resume()
        
        
    }
}

