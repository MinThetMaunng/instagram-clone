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
    
    func loginRequest(body: [String: String], completion: @escaping (Result<LoginResult, Error>) -> ()) {
        guard let url = URL(string: LOGIN_URL) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: .init())
        } catch(let err) {
            print("JSON Serialization error : \(err)")
            completion(.failure(err))
        }
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {

                guard let data = data else { return }
                do {
                    let jsonResult = try JSONDecoder().decode(LoginResult.self, from: data)
                    completion(.success(jsonResult))
                } catch(let err) {
                    completion(.failure(err))
                }
            }
            
        }.resume()
        
    }
}
