//
//  PostsNetworkServices.swift
//  social-media
//
//  Created by Eduardo Dias on 12/07/21.
//

import Combine
import Foundation

protocol PostsFetcher {
    func fetchPosts() -> AnyPublisher<[Post], Error>
}

class PostsNetworkServices: PostsFetcher, NetworkService {
    
    var restClient: RestClient { URLSession.shared }
    
    func fetchPosts() -> AnyPublisher<[Post], Error> {
        get(url: "\(Environment.URLS.base)/posts")
    }
    
    func fetchCommentsFromPost(_ id: Int) -> AnyPublisher<[Comment], Error> {
        get(url: "\(Environment.URLS.base)/posts/\(id)/comments")
    }
}
