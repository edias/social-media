//
//  SearchBar.swift
//  social-media
//
//  Created by Eduardo Dias on 13/07/21.
//

import SwiftUI

struct SearchBar: View {
    
    @Binding
    var searchText: String
    
    var body: some View {
        
        HStack {
            
        TextField("Search...", text: $searchText)
            .padding(7)
            .background(Color(.systemGray6))
            .cornerRadius(8)
            .padding(.horizontal, 10)
            .overlay (
                HStack {
                    Spacer()
                    Button(action: {
                        self.searchText = ""
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                                        to: nil, from: nil, for: nil)
                    }) {
                        Image(systemName: "multiply.circle.fill")
                            .foregroundColor(.gray)
                            .padding(.trailing, 8)
                    }.padding(.trailing, 10)
                }
            )
        }
    }
}
