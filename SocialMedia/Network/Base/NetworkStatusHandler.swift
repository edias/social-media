//
//  NetworkStatusHandler.swift
//  SocialMedia
//
//  Created by Eduardo Dias on 12/07/21.
//

import Foundation

enum StatusCodeError: Error {
    case responseIsInvalid
    case forbidden
    case internalServerError
    case missingApiKeyHashOrTimestamp
    case invalidRefererOrHash
    case methodNotAllowed
    case unknownError
}

typealias Output = URLSession.DataTaskPublisher.Output

struct NetworkStatusHandler {
    
    static func handleOutput(_ output: Output) throws -> Output {
        
        guard let response = output.response as? HTTPURLResponse else {
            throw StatusCodeError.responseIsInvalid
        }
        
        switch response.statusCode {
            case 200 ..< 300:
                return output
            case 401:
                throw StatusCodeError.invalidRefererOrHash
            case 403:
                throw StatusCodeError.forbidden
            case 405:
                throw StatusCodeError.methodNotAllowed
            case 409:
                throw StatusCodeError.missingApiKeyHashOrTimestamp
            case 500:
                throw StatusCodeError.internalServerError
            default:
                throw StatusCodeError.unknownError
        }
    }
}
