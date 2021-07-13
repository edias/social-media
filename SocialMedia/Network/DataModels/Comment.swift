//
//  Comment.swift
//  social-media
//
//  Created by Eduardo Dias on 12/07/21.
//

import Foundation

struct Comment: Codable, Hashable {
    let name: String
    let email: String
    let body: String
}
