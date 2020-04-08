//
//  FollowApiService.swift
//  Instagram
//
//  Created by Min Thet Maung on 27/03/2020.
//  Copyright © 2020 Myanmy. All rights reserved.
//

import UIKit

class FollowApiService {
    public static let instance = FollowApiService()
    
    func followOrUnfollowAUser(by who: String, to whom: String, completion: @escaping (Result<FollowOrUnfollowResponse, Error>) -> ()) {
        guard let url = URL(string: "\(FOLLOW_OR_UNFOLLOW_URL)") else { return }
        let parameters = ["whoFollow": who, "toWhom": whom]
        
        var request = URLRequest(url: url)
        request.setValue(AuthService.instance.jwtToken, forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .init())
        } catch(let err) {
            print("JSON Serilization error: in follow route ")
            print(err.localizedDescription)
        }
        
        URLSession.shared.dataTask(with: request) { (data, response, err) in
            DispatchQueue.main.async {
                guard let data = data else { return }
                do {
                    let jsonResult = try JSONDecoder().decode(FollowOrUnfollowResponse.self, from: data)
                    completion(.success(jsonResult))
                } catch(let err) {
                    print("Error in Follow unfollow route URLSession")
                    completion(.failure(err))
                }
            }
        }.resume()
    }
    
    
}
