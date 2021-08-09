//
//  NewsListView.swift
//  NewsListView
//
//  Created by Anna Zharkova on 09.08.2021.
//

import SwiftUI

struct NewsListView: View {
    @State var items = MockHelper.shared.mockItems
    
    var body: some View {
        NavigationView {
        if #available(iOS 15.0, *) {
            List(items) { item in
                NavigationLink {
                    NewsItemView(item: item)
                } label: {
                    NewsItemRow(item: item)
                }

            }.refreshable {
                self.items = MockHelper.shared.mockItems
            }.navigationBarTitle("News", displayMode: .inline).navigationBarItems(trailing: NavigationLink(destination: {
                SearchView()
            }, label: {
                Color.blue.frame(width: 40, height: 40, alignment: .topTrailing)
            }))
        } else {
            List(items) { item in
                NavigationLink {
                    NewsItemView(item: item)
                } label: {
                    NewsItemRow(item: item)
                }

            }.navigationBarTitle("News", displayMode: .inline).navigationBarItems(trailing: NavigationLink(destination: {
                SearchView()
            }, label: {
                Color.blue.frame(width: 40, height: 40, alignment: .topTrailing)
            }))
        }
        }
    }
}

struct NewsListView_Previews: PreviewProvider {
    static var previews: some View {
        NewsListView()
    }
}
