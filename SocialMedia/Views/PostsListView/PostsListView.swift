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
                    .unredacted(when: viewModel.postsLoaded)
                }
            }.navigationTitle("Posts")
        }
        .onAppear { viewModel.loadPosts() }
        .navigationViewStyle(StackNavigationViewStyle())
        .errorView(viewModel.errorType, retryAction: { viewModel.loadPosts() })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        PostsListView()
    }
}
