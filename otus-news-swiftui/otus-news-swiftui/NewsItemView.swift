//
//  NewsItemView.swift
//  NewsItemView
//
//  Created by Anna Zharkova on 09.08.2021.
//

import SwiftUI

struct NewsItemView: View {
    @State var item: NewsItem
    
    var body: some View {
        GeometryReader { reader in
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    if #available(iOS 15.0, *) {
                        AsyncImage(url: URL(string: item.urlToImage ?? "")) { image in
                            image.frame(width: reader.size.width - 20, height: 250, alignment: .center).aspectRatio(contentMode: .fill).clipped()
                        } placeholder: {
                            Color.red.frame(width: reader.size.width - 20, height: 100, alignment: .center)
                        }
                    } else {
                        CachedImage(url: item.urlToImage ?? "")
                    }
                    
                    Text(item.title ?? "").largeTitle()
                    Text(item.dateString).smallTitle()
                    Text(item.content ?? "").subtextTitle()
                    Button {
                        UIApplication.shared.open(URL(string: item.url ?? "")!, options: [:], completionHandler: nil)
                    } label: {
                        Text("Show more").smallTitle()
                    }
                    Spacer()
                }.padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
            }
        }
    }
}

