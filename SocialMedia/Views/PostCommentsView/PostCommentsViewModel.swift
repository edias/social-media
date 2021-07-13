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
    private (set) var commentsFetched = false
    
    @Published
    private (set) var comments: [Comment] = []
    
    private var cancellable: AnyCancellable?
    
    private var postsFetcher: PostsFetcher
    
    init(_ postsFetcher: PostsFetcher = PostsNetworkServices()) {
        self.postsFetcher = postsFetcher
    }
    
    func fetchComments(_ postId: Int) {
        
        initializePlaceHolders()
        
        cancellable = postsFetcher.fetchCommentsFromPost(postId)
            .receive(on: RunLoop.main).sink { _ in }
                receiveValue: { [weak self] comments in
                    self?.comments = comments
                    self?.commentsFetched = true
                }
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
