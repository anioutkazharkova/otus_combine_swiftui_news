//
//  SearchViw.swift
//  SearchViw
//
//  Created by Anna Zharkova on 09.08.2021.
//

import SwiftUI

struct SearchView: View {
    @ObservedObject var model = SearchModel()
    @State var text: String = ""
    
    var body: some View {
        /*if #available(iOS 15.0, *) {
            List(model.foundItems) { item in
                NavigationLink {
                    NewsItemView(item: item)
                } label: {
                    NewsItemRow(item: item)
                }

            }.searchable(text: self.$text).onChange(of: text, perform: { newValue in
                self.model.search(query: newValue)
            }).navigationBarTitle("Search", displayMode: .inline)
        } else {*/
            VStack {
            SearchBar(text: $text) { text in
                self.model.search(query: text)
            }
            List(model.foundItems) { item in
                NavigationLink {
                    NewsItemView(item: item)
                } label: {
                    NewsItemRow(item: item)
                }

            }}.navigationBarTitle("Search", displayMode: .inline)
        //}
    }
}

class SearchModel : ObservableObject {
    var cachedItems  = MockHelper.shared.mockItems
    @Published var foundItems = [NewsItem] ()
    
    func search(query: String) {
        if query.count > 2 {
            foundItems = cachedItems.filter { ($0.content?.lowercased() ?? "").contains(query.lowercased())}
        }
    }
}



