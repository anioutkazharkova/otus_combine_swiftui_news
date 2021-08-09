//
//  NewsItemRow.swift
//  NewsItemRow
//
//  Created by Anna Zharkova on 09.08.2021.
//

import SwiftUI

struct NewsItemRow: View {
    @State var item: NewsItem
    
    var body: some View {
        HStack(alignment: .top) {
            if #available(iOS 15.0, *) {
                AsyncImage(url: URL(string: item.urlToImage ?? "")) { image in
                    image.frame(width: 100, height: 100, alignment: .center).aspectRatio(contentMode: .fill).clipped()
                } placeholder: {
                    Color.red.frame(width: 100, height: 100, alignment: .center)
                }
            } else {
                ThumbImage(url: item.urlToImage ?? "").frame(width: 100, height: 100)
            }

          //
            VStack(alignment: .leading, spacing: 7) {
                Text(item.title ?? "").lineLimit(4).textTitle()
                Text(item.description ?? "").lineLimit(4).subtextTitle()
                Text(item.publishedAt?.formatToString("dd.MM.yyyy") ?? "").smallTitle()
            }
        }.background(Color.white)
    }
}
