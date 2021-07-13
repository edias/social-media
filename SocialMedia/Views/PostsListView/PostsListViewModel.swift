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
    private (set) var postsFetched = false
    
    @Published
    private (set) var posts: [Post] = []
    
    private var cancellable: AnyCancellable?
    
    private var postsFetcher: PostsFetcher
    
    init(_ postsFetcher: PostsFetcher = PostsNetworkServices()) {
        self.postsFetcher = postsFetcher
    }
    
    func fetchPosts() {
        
        initializePlaceHolders()
        
        cancellable = postsFetcher.fetchPosts()
            .receive(on: RunLoop.main).sink { _ in }
        receiveValue: { [weak self] newPosts in
            self?.posts = newPosts
            self?.postsFetched = true
        }
    }
    
    private func initializePlaceHolders() {
            postsFetched = false
            posts = (0...11).map { Post(id: $0,
                                        title: "Placeholder",
                                        body: "Alias alias cumque. Voluptatem ipsa repudiandae ipsum reiciendis illo. Incidunt rerum id architecto doloribus." ) }
        }
}
