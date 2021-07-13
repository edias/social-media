//
//  Environment.swift
//  social-media
//
//  Created by Eduardo Dias on 12/07/21.
//

import Foundation

struct Environment {
    
    enum URLS: String {
        case base = "https://jsonplaceholder.typicode.com"
    }
}

extension Environment.URLS: CustomStringConvertible {
    var description: String { rawValue }
}
