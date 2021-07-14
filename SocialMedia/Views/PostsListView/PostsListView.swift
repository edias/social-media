//
//  ContentView.swift
//  social-media
//
//  Created by Eduardo Dias on 12/07/21.
//

import Combine
import SwiftUI

struct PostsListView: View {
    
    @ObservedObject
    private var viewModel = PostsListViewModel()
    
    @State
    private var selection: Int? = nil
    
    var body: some View {
        
        NavigationView {
            
            VStack {
                
                SearchBar(searchText: $viewModel.searchText)
                
                ScrollView {
                    ForEach(viewModel.posts, id: \.self) { post in
                        
                        PostView(post: post, selection: $selection)
                        
                        NavigationLink(destination: PostCommentsView(post: post),
                                       tag: post.id,
                                       selection: $selection) {}
                    }
                    .listStyle(GroupedListStyle())
                    .unredacted(when: viewModel.postsFetched)
                }
            }.navigationTitle("Posts")
        }
        .onAppear { viewModel.fetchPosts() }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        PostsListView()
    }
}

extension View {
    
    @ViewBuilder
    func unredacted(when condition: Bool) -> some View {
        if condition {
            unredacted()
        } else {
            redacted(reason: .placeholder)
        }
    }
}
