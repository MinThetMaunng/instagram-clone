//
//  PostApiService.swift
//  Instagram
//
//  Created by Min Thet Maung on 14/03/2020.
//  Copyright © 2020 Myanmy. All rights reserved.
//

import UIKit

class PostApiService {
    static let instance = PostApiService()
    
    func getPostsByUser(userId: String, limit: Int, skip: Int, completion: @escaping (Result<GetUserPostsResponse,Error>) ->() ) {
        guard let url = URL(string: "\(GET_ALL_POST_URL)/\(userId)?limit=\(limit)&skip=\(skip)") else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            DispatchQueue.main.async {
                guard let data = data else { return }
                do {
                    let jsonData = try JSONDecoder().decode(GetUserPostsResponse.self, from: data)
                    completion(.success(jsonData))
                } catch(let err) {
                    completion(.failure(err))
                }
            }
        }.resume()
    }
    
    func getPostsRequest(limit: Int, skip: Int, completion: @escaping (Result<GetAllPostResponse, Error>) -> ()) {
        guard let url = URL(string: "\(GET_ALL_POST_URL)?sort=-createdAt&limit=\(limit)&skip=\(skip)") else { return }
        var request = URLRequest(url: url)
        request.setValue("Authorization", forHTTPHeaderField: "\(AuthService.instance.jwtToken)")
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                guard let data = data else { return }
                do {
                    let jsonResult = try JSONDecoder().decode(GetAllPostResponse.self, from: data)
                    completion(.success(jsonResult))
                } catch(let err) {
                    completion(.failure(err))
                }
            }
        }.resume()
    }
    
    func createPostRequest(body: Parameters, image: UIImage, completion: @escaping (Result<CreatePostResponse , Error>) -> ()) {
       
        guard let imageData = Image(withImage: image, forKey: "image") else { return }
        guard let url = URL(string: CREATE_POST_URL) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let boundary = ApiService.instance.generateBoundary()
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        let dataBody = ApiService.instance.createDataBody(withParameters: body, medias: [imageData], boundary: boundary)
        request.httpBody = dataBody
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                
                guard let data = data else { return }
                do {
                    let jsonResult = try JSONDecoder().decode(CreatePostResponse.self, from: data)
                    completion(.success(jsonResult))
                } catch(let err) {
                    completion(.failure(err))
                }
            }
        }.resume()
        
    }
   
}
