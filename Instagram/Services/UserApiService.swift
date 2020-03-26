//
//  UserApiService.swift
//  Instagram
//
//  Created by Min Thet Maung on 14/03/2020.
//  Copyright © 2020 Myanmy. All rights reserved.
//

import UIKit

class UserApiService {
    static let instance = UserApiService()
    
    func getUsers(limit: Int? = 0, skip: Int? = 0, username: String = "", completion:@escaping (Result<GetUsersResponse, Error>) -> ()) {
        guard let url = URL(string: "\(GET_All_USERS)?limit=\(limit)&skip=\(skip)&username=\(username)") else { return }
        var request = URLRequest(url: url)
        request.setValue(AuthService.instance.jwtToken, forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                guard let data = data else { return }
                do {
                    let jsonResult = try JSONDecoder().decode(GetUsersResponse.self, from: data)
                    completion(.success(jsonResult))
                } catch(let err) {
                    completion(.failure(err))
                }
            }
        }.resume()
    }
    
    func getUserProfile(completion: @escaping (Result<GetUserProfileResponse, Error>) -> () ) {
        guard let url = URL(string: "\(GET_PROFILE)\(AuthService.instance.userId)") else { return }
        var request = URLRequest(url: url)
        request.setValue(AuthService.instance.jwtToken, forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                guard let data = data else { return }
                do {
                    let jsonResult = try JSONDecoder().decode(GetUserProfileResponse.self, from: data)
                    completion(.success(jsonResult))
                } catch(let err) {
                    completion(.failure(err))
                }
            }
        }.resume()
    }
    
    func loginRequest(body: Parameters, completion: @escaping (Result<LoginResponse , Error>) -> ()) {
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
                    let jsonResult = try JSONDecoder().decode(LoginResponse.self, from: data)
                    completion(.success(jsonResult))
                } catch(let err) {
                    completion(.failure(err))
                }
            }
            
        }.resume()
        
    }
    
    func signupRequest(parameters: Parameters,image: UIImage, completion: @escaping (Result<SignupResponse, Error>) -> ()) {
        
        guard let imageData = Image(withImage: image, forKey: "image") else { return }
        guard let url = URL(string: SIGNUP_URL) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let boundary = ApiService.instance.generateBoundary()
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        let dataBody = ApiService.instance.createDataBody(withParameters: parameters, medias: [imageData], boundary: boundary)
        request.httpBody = dataBody
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                
                guard let data = data else { return }
                do {
                    let jsonResult = try JSONDecoder().decode(SignupResponse.self, from: data)
                    completion(.success(jsonResult))
                } catch(let err) {
                    completion(.failure(err))
                }
            }
        }.resume()
        
    }
    
   
}
