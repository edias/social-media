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
    var searchText = ""
    
    private var susbcriptions = Set<AnyCancellable>()
    
    @Published
    private (set) var postsFetched = false
    
    private var allPosts: [Post] = []
    
    @Published
    private (set) var posts: [Post] = []
    
    private var postsFetcher: PostsFetcher
    
    init(_ postsFetcher: PostsFetcher = PostsNetworkServices()) {
        self.postsFetcher = postsFetcher
        setupSearchSubscription()
    }
    
    func fetchPosts() {
        
        initializePlaceHolders()
        
        postsFetcher.fetchPosts()
            .receive(on: RunLoop.main).sink { _ in }
        receiveValue: { [weak self] newPosts in
            self?.allPosts = newPosts
            self?.postsFetched = true
            self?.searchText = ""
        }.store(in: &susbcriptions)
    }
    
    private func setupSearchSubscription() {
        $searchText.receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] text in
                guard let self = self else { return }
                guard !text.isEmpty else {
                    self.posts = self.allPosts
                    return
                }
                self.posts = self.allPosts.filter { post in
                    let postTitle = post.title.lowercased()
                    let postBody = post.body.lowercased()
                    let searchedText = text.lowercased()
                    return postTitle.contains(searchedText) || postBody.contains(searchedText)
                }
            }).store(in: &susbcriptions)
    }
    
    private func initializePlaceHolders() {
            postsFetched = false
            posts = (0...11).map { Post(id: $0,
                                        title: "Placeholder",
                                        body: "Alias alias cumque. Voluptatem ipsa repudiandae ipsum reiciendis illo. Incidunt rerum id architecto doloribus." ) }
        }
}
