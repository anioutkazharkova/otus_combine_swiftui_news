//
//  SearchBar.swift
//  SearchBar
//
//  Created by Anna Zharkova on 09.08.2021.
//

import SwiftUI



struct SearchBar: UIViewRepresentable {

    
    @Binding var text: String
    var action: ((String)->Void)? = nil
    
    func makeCoordinator() -> SearchBar.Coordinator {
        let coordinator = Coordinator(text: $text)
        coordinator.action = action
        return coordinator
    }
    
    func makeUIView(context: UIViewRepresentableContext<SearchBar>) -> UISearchBar{
        let searchBar = UISearchBar(frame: .zero)
        searchBar.delegate = context.coordinator
        searchBar.autocapitalizationType = .none
        return searchBar
    }
    
    func updateUIView(_ uiView: UISearchBar, context: UIViewRepresentableContext<SearchBar>) {
        uiView.text = text 
    }
    
    class Coordinator: NSObject, UISearchBarDelegate {
        var action: ((String)->Void)? = nil
        @Binding var text: String
        
        init(text: Binding<String>) {
            _text = text
        }
        
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            text = searchText
            action?(searchText)
        }
        
        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            searchBar.resignFirstResponder()
            searchBar.endEditing(true)
        }
        
        func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
            searchBar.text = ""
            searchBar.resignFirstResponder()
            searchBar.showsCancelButton = false
            searchBar.endEditing(true)
        }
    }
}


