//
//  SearchModel.swift
//  SearchModel
//
//  Created by Anna Zharkova on 10.08.2021.
//

import Foundation
import SwiftUI
import Combine

class SearchModel : ObservableObject {
    weak var service = NewsService.shared
    @Published var foundItems = [NewsItem] ()
    var subscriptions = Set<AnyCancellable>()
    
    func search(query: String) {
        if query.count > 2 {
            self.searchQuery(query: query)
        }
    }
    /*
    func search(query: String) {
        if query.count > 2 {
            service?.searchNews(query: query, completion: { result in
                switch result {
                case .success(let data):
                    self.foundItems = [NewsItem]()
                    self.foundItems.append(contentsOf: data.articles ?? [NewsItem]())
                case .failure(let error):
                    if let error = error as? ErrorResponse {
                        print(error.message)
                    } else {
                        print(error.localizedDescription)
                    }
                }
            })
        }
    }*/
    
    private func searchQuery(query: String) {
        _ = service?.searchNewsPublisher(query: query).sink(receiveCompletion: { completion in
            switch completion {
            case .failure(let error):
                print(error.localizedDescription)
            case .finished:
                print("finished")
            }
        }, receiveValue: { list in
            self.foundItems = [NewsItem]()
            self.foundItems.append(contentsOf: list.articles ?? [NewsItem]())
        }).store(in: &subscriptions)
    }
}
