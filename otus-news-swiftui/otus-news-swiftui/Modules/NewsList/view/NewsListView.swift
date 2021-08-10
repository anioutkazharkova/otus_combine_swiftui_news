//
//  NewsListView.swift
//  NewsListView
//
//  Created by Anna Zharkova on 09.08.2021.
//

import SwiftUI
import SwiftUINavigator

struct NewsListView: IItemView {
    var listener: INavigationContainer?
    @ObservedObject var model = NewsListModel()
    
    var body: some View {
        NavigationView {
            if #available(iOS 15.0, *) {
                List(model.items) { item in
                    NewsItemRow(item: item).onTapGesture {
                        self.listener?.push(view: NewsItemView(item: item))
                    }
                    
                }.refreshable {
                    model.loadNews()
                }.onAppear{
                    model.loadNews()
                }.navigationBarTitle("News", displayMode: .inline).navigationBarItems(trailing:  Color.blue.frame(width: 40, height: 40, alignment: .topTrailing).onTapGesture {
                    self.listener?.push(view: SearchView())
                })
            } else {
                List(model.items) { item in
                    NavigationLink {
                        NewsItemView(item: item)
                    } label: {
                        NewsItemRow(item: item)
                    }
                    
                }.onAppear{
                    model.loadNewsOld()
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
