//
//  PostsViewModel.swift
//  social-media
//
//  Created by Eduardo Dias on 13/07/21.
//

import Combine
import Foundation

class PostsListViewModel: ObservableObject {
    
    @Published
    private (set) var posts: [Post] = []
    
    private var cancellable: AnyCancellable?
    
    private var postsFetcher: PostsFetcher
    
    init(_ postsFetcher: PostsFetcher = PostsNetworkServices()) {
        self.postsFetcher = postsFetcher
    }
    
    func fetchPosts() {
        cancellable = postsFetcher.fetchPosts()
            .receive(on: RunLoop.main).sink { _ in }
        receiveValue: { [weak self] newPosts in
            self?.posts = newPosts
        }
    }
}
