//
//  Post.swift
//  social-media
//
//  Created by Eduardo Dias on 12/07/21.
//

import Foundation

struct Post: Codable, Hashable {
    let id: Int
    let title: String
    let body: String
}
