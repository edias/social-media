//
//  PostCommentsViewModel.swift
//  social-media
//
//  Created by Eduardo Dias on 13/07/21.
//

import Combine
import Foundation

class PostCommentsViewModel: ObservableObject {
    
    @Published
    var searchText = ""
    
    @Published
    private (set) var commentsFetched = false
    
    @Published
    private (set) var comments: [Comment] = []
    
    private var susbcriptions = Set<AnyCancellable>()
    private var postsFetcher: PostsFetcher
    private var allComments: [Comment] = []
    
    init(_ postsFetcher: PostsFetcher = PostsNetworkServices()) {
        self.postsFetcher = postsFetcher
        setupSearchSubscription()
    }
    
    func fetchComments(_ postId: Int) {
        
        initializePlaceHolders()
        
        postsFetcher.fetchCommentsFromPost(postId)
            .receive(on: RunLoop.main).sink { _ in }
                receiveValue: { [weak self] comments in
                    self?.allComments = comments
                    self?.comments = comments
                    self?.commentsFetched = true
                }.store(in: &susbcriptions)
    }
    
    private func setupSearchSubscription() {
        $searchText.receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] text in
                guard let self = self else { return }
                guard !text.isEmpty else {
                    self.comments = self.allComments
                    return
                }
                self.comments = self.allComments.filter { comment in
                    let commentName = comment.name.lowercased()
                    let commentBody = comment.body.lowercased()
                    let searchedText = text.lowercased()
                    return commentName.contains(searchedText) || commentBody.contains(searchedText)
                }
            }).store(in: &susbcriptions)
    }

    
    private func initializePlaceHolders() {
        
        commentsFetched = false
        
        comments = (0...11).map { _ -> Comment in
            Comment(name: "Placeholder",
                    email: "yturner@hotmail.com",
                    body: "Alias alias cumque. Voluptatem ipsa repudiandae ipsum reiciendis illo. Incidunt rerum id architecto doloribus." )
        }
    }
}
