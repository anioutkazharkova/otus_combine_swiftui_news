//
//  Requests.swift
//  Requests
//
//  Created by Anna Zharkova on 10.08.2021.
//

import Foundation
enum Requests {
    case everything(query: String)
    case top
    
    var value: String {
        switch self {
        case .everything(let query):
            return "everything?q=\(query)"
        case .top:
            return "top-headlines?language=en"
        }
    }
}
