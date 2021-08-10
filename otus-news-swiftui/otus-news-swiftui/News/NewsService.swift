//
//  NewsService.swift
//  NewsService
//
//  Created by Anna Zharkova on 10.08.2021.
//

import Foundation
import Combine

class NewsService {
    static let shared = NewsService()
    private let networkService: NetworkService
    
    init() {
        self.networkService = NetworkService()
    }
    
    func searchNews(query: String, completion: @escaping(Result<NewsList,Error>)->Void) {
        networkService.request(path: Requests.everything(query: query).value, method: .get) { (result: Result<NewsList,Error>) in
            completion(result)
        }
    }
    
    func loadNews(completion: @escaping(Result<NewsList,Error>)->Void) {
        networkService.request(path: Requests.top.value, method: .get) { (result: Result<NewsList,Error>) in
            completion(result)
        }
    }
    
    func searchNewsPublisher(query: String)->AnyPublisher<NewsList,Error> {
        return networkService.requestPublisher(path: Requests.everything(query: query).value, method: .get)
    }
    
    func loadNewsPublisher()->AnyPublisher<NewsList,Error> {
        return networkService.requestPublisher(path: Requests.top.value, method: .get)
    }
    
    @available(iOS 15.0, *)
    func searchNewsAsync(query: String) async -> Result<NewsList,Error> {
        do {
            let finalResult =  try await withCheckedThrowingContinuation({ (continuation:CheckedContinuation<NewsList,Error> ) in
                networkService.request(path: Requests.everything(query: query).value, method: .get) { (result: Result<NewsList,Error>) in
                    switch result {
                    case .success(_):
                        continuation.resume(with: result)
                    case .failure(let error):
                        continuation.resume(throwing: error)
                    }
                }
            })
            return Result.success(finalResult)
        }
        catch {
            return Result.failure(error)
        }
    }
    
    @available(iOS 15.0, *)
    func loadNewsAsync() async -> Result<NewsList,Error> {
        do {
            let finalResult =  try await withCheckedThrowingContinuation({ (continuation:CheckedContinuation<NewsList,Error> ) in
                networkService.request(path: Requests.top.value, method: .get){ (result: Result<NewsList,Error>) in
                    switch result {
                    case .success(_):
                        continuation.resume(with: result)
                        break
                    case .failure(let error):
                        continuation.resume(throwing: error)
                        break
                    }
                }
            })
            return Result.success(finalResult)
        }
        catch {
            return Result.failure(error)
        }
    }
    
    @available(iOS 15.0, *)
    func loadNewsAsyncExt() async -> Result<NewsList,Error> {
        return await networkService.requestAsynce(path: Requests.top.value, method: .get)
    }
}
