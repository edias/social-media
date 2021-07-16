//
//  MockBuilder.swift
//  social-media
//
//  Created by Eduardo Dias on 16/07/21.
//

import Foundation

class MockBuilder {
    
    static func makePosts() -> [Post] {
        (0...11).map { Post(id: $0,
                            title: "Placeholder",
                            body: "Alias alias cumque. Voluptatem ipsa repudiandae ipsum reiciendis illo. Incidunt rerum id architecto doloribus.")
        }
    }
    
    static func makeComments() -> [Comment] {
        (0...11).map { _ -> Comment in
            Comment(name: "Placeholder",
                    email: "yturner@hotmail.com",
                    body: "Alias alias cumque. Voluptatem ipsa repudiandae ipsum reiciendis illo. Incidunt rerum id architecto doloribus.")
        }
    }
}
