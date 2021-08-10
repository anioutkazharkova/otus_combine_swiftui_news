//
//  NetworkConfiguration.swift
//  NetworkConfiguration
//
//  Created by Anna Zharkova on 10.08.2021.
//

import Foundation

class NetworkConfiguration {

    private let apiUrl = "https://newsapi.org/v2/"
    private let apiKey = "5b86b7593caa4f009fea285cc74129e2"

    func getHeaders() -> [String: String] {
        return ["X-Api-Key":apiKey]
    }

    func getBaseUrl() -> String {
        return apiUrl
    }

}
