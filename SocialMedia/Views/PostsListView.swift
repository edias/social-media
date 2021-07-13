//
//  ContentView.swift
//  social-media
//
//  Created by Eduardo Dias on 12/07/21.
//

import Combine
import SwiftUI

import Combine
import SwiftUI

struct PostsListView: View {
    
    @ObservedObject
    private var viewModel = PostsListViewModel()
    
    var body: some View {
        
        NavigationView {
            List {
                ForEach(viewModel.posts, id: \.self) { post in
                    PostView(post: post)
                }
            }
            .navigationTitle("Posts")
            .onAppear { viewModel.fetchPosts() }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        PostsListView()
    }
}
