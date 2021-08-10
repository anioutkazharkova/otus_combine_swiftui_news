//
//  NewsListModel.swift
//  NewsListModel
//
//  Created by Anna Zharkova on 10.08.2021.
//

import Foundation
import SwiftUI
import Combine

class NewsListModel : ObservableObject {
    weak var service = NewsService.shared
    @Published var items: [NewsItem] = [NewsItem]()
    var subscriptions = Set<AnyCancellable>()
    
    @available(iOS 15.0, *)
    func loadNews() {
        Task {
            if let result =  await service?.loadNewsAsync() { 
                switch result {
                case .success(let data):
                    await self.perform {
                        self.items = [NewsItem]()
                        self.items.append(contentsOf: data.articles ?? [NewsItem]())
                    }
                    //await updateWithData(items: data.articles ?? [NewsItem]())
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            
        }
    }
    
    @available(iOS 15.0, *)
    @MainActor
    private func updateWithData(items:[NewsItem]) {
        self.items = [NewsItem]()
        self.items.append(contentsOf: items)
    }
    
    @available(iOS 15.0, *)
    @MainActor
    private func perform(action: @escaping()->Void) {
        action()
    }
    
    func loadNewsOld() {
        _ = service?.loadNewsPublisher().sink(receiveCompletion: { completion in
            switch completion {
            case .failure(let error):
                print(error.localizedDescription)
            case .finished:
                print("finished")
            }
        }, receiveValue: { list in
            self.items = [NewsItem]()
            self.items.append(contentsOf: list.articles ?? [NewsItem]())
        }).store(in: &subscriptions)
    }
    
    /*func loadNews() {
     service?.loadNews(completion: { result in
     switch result {
     case .success(let data):
     self.items = [NewsItem]()
     self.items.append(contentsOf: data.articles ?? [NewsItem]())
     case .failure(let error):
     if let error = error as? ErrorResponse {
     print(error.message)
     } else {
     print(error.localizedDescription)
     }
     }
     })
     }*/
}
