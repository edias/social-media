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
    var selection: Int? = nil
    
    var body: some View {
        
        NavigationView {
            
            ScrollView {
                
                ForEach(viewModel.posts, id: \.self) { post in
                    
                    PostView(post: post, selection: $selection)
                    
                    NavigationLink(destination: PostCommentsView(post: post),
                                   tag: post.id,
                                   selection: $selection) {}
                }
            }
            .navigationTitle("Posts")
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
