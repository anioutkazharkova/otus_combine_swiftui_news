//
//  SearchViw.swift
//  SearchViw
//
//  Created by Anna Zharkova on 09.08.2021.
//

import SwiftUI
import SwiftUINavigator

struct SearchView: IItemView {
    var listener: INavigationContainer?
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
        NavigationView{
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

            }}.navigationBarTitle("Search", displayMode: .inline).navigationBarItems(leading:  Color.blue.frame(width: 40, height: 40, alignment: .topLeading).onTapGesture {
                self.listener?.pop()
            })
        }
        //}
    }
}




