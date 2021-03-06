//
//  otus_news_swiftuiApp.swift
//  otus-news-swiftui
//
//  Created by Anna Zharkova on 09.08.2021.
//

import SwiftUI
import SwiftUINavigator

@main
struct otus_news_swiftuiApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationContainerView(transition: .custom(.opacity), content: {
                NewsListView()
            })
        }
    }
}
