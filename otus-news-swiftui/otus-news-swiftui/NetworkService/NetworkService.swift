//
//  NetworkService.swift
//  NetworkService
//
//  Created by Anna Zharkova on 10.08.2021.
//

import Foundation
import Combine

enum Method: String {
    case get = "GET"
    case post = "POST"
    
    var value: String {
        return self.rawValue
    }
}

class NetworkService {
    private var configuration = NetworkConfiguration()
    
    func request<T:Codable>(path: String, method: Method, parameters: [String:Any] = [:],
                    completion: @escaping(Result<T,Error>)->Void) {
        let apiPath = "\(configuration.getBaseUrl())\(path)"
        guard let url = URL(string: apiPath) else {
            DispatchQueue.main.async {
                completion(Result.failure(ErrorResponse(type: .other)))
            }
            return
        }
        var request = URLRequest(url: url)
        let headers = configuration.getHeaders()
        for header in headers {
            request.addValue(header.value, forHTTPHeaderField: header.key)
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data, let response = response as? HTTPURLResponse {
                let content = JsonHelper.shared.decodeData(response: response, data: data, T.self)
                DispatchQueue.main.async {
                  completion(content)
                }
            }
            else  {
                DispatchQueue.main.async {
                completion(Result.failure(ErrorResponse(type: .network)))
            }
            }
        }
        task.resume()
        
    }
    
    @available(iOS 15.0, *)
    func requestAsynce<T:Codable>(path: String, method: Method, parameters: [String:Any] = [:]) async ->Result<T,Error> {
        let apiPath = "\(configuration.getBaseUrl())\(path)"
        guard let url = URL(string: apiPath) else {
            return Result.failure(ErrorResponse(type: .other))
        }
        var request = URLRequest(url: url)
        let headers = configuration.getHeaders()
        for header in headers {
            request.addValue(header.value, forHTTPHeaderField: header.key)
        }
        
        do {
            let task = try await URLSession.shared.data(for: request)
            let data = task.0
            if let response = task.1 as? HTTPURLResponse {
            let content = JsonHelper.shared.decodeData(response: response, data: data, T.self)
            return content
            }
            return Result.failure(ErrorResponse(type: .other))
        }
        catch {
            return Result.failure(error)
        }
        
        /*
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data, let response = response as? HTTPURLResponse {
                let content = JsonHelper.shared.decodeData(response: response, data: data, T.self)
                DispatchQueue.main.async {
                  completion(content)
                }
            }
            DispatchQueue.main.async {
                completion(Result.failure(ErrorResponse(type: .network)))
            }
        }
        task.resume()
        */
    }
    
    func requestPublisher<T:Codable>(path: String, method: Method, parameters: [String:Any] = [:]) -> AnyPublisher<T,Error> {
        let apiPath = "\(configuration.getBaseUrl())\(path)"
        guard let url = URL(string: apiPath) else {
            return Result<T,Error>.Publisher(ErrorResponse(type: .other)).eraseToAnyPublisher()
        }
        var request = URLRequest(url: url)
        let headers = configuration.getHeaders()
        for header in headers {
            request.addValue(header.value, forHTTPHeaderField: header.key)
        }
        
        let task = URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { (data,response) -> T in
                if let response = response as? HTTPURLResponse {
                    let content = JsonHelper.shared.decodeData(response: response, data: data, T.self)
                    switch content {
                    case .success(let result):
                        return result
                    case .failure(let error):
                        throw error
                    }
                }
                throw ErrorResponse(type: .network)
            }.mapError { error -> Error in
                return error
            }.receive(on: DispatchQueue.main).eraseToAnyPublisher()
        
        
        
        /* { data, response, error in
            if let data = data, let response = response as? HTTPURLResponse {
                let content = JsonHelper.shared.decodeData(response: response, data: data, T.self)
                DispatchQueue.main.async {
                  completion(content)
                }
            }
            DispatchQueue.main.async {
                completion(Result.failure(ErrorResponse(type: .network)))
            }
        }
        task.resume()*/
        return task
    }
}
