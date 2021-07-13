//
//  Serializer.swift
//  SocialMedia
//
//  Created by Eduardo Dias on 12/07/21.
//

import Foundation

class Serializer {
    
    static let shared = Serializer()

    private init() {}
    
    private lazy var decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    
    func deserialize<D: Decodable>(_ type: D.Type, data: Data) throws -> D {
        
        do {
            return try decoder.decode(type, from: data)
        } catch let error {
            
            guard let decodingError = error as? DecodingError else {
                throw error
            }

            print(decodingError)
            
            throw error
        }
    }
}
