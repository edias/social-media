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
    var errorType: ErrorType?
    
    @Published
    var searchText = ""
    
    @Published
    private (set) var postsLoaded = false
    
    @Published
    private (set) var posts: [Post] = []
    
    private var postsFetcher: PostsFetcher
    private var susbcriptions = Set<AnyCancellable>()
    private var allPosts: [Post] = [] {
        didSet {
            postsLoaded = true
        }
    }
    
    init(_ postsFetcher: PostsFetcher = PostsNetworkServices()) {
        self.postsFetcher = postsFetcher
        setupSearchSubscription()
    }
    
    func loadPosts() {
        
        initializePlaceHolders()
        
        postsFetcher.fetchPosts().receive(on: RunLoop.main).sink { [weak self] error in
            self?.handleError(error)
        } receiveValue: { [weak self] posts in
            self?.allPosts = posts
            self?.posts = posts
            self?.errorType = nil
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
        postsLoaded = false
        posts = MockBuilder.makePosts()
    }
    
    private func handleError(_ error: Subscribers.Completion<Error>) {
        switch error {
            case .failure(let error as NSError) where error.code == NSURLErrorNotConnectedToInternet:
                errorType = .offline
            case .failure:
                errorType = .generic
            default:
                errorType = nil
        }
    }
}
