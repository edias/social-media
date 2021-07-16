//
//  MockRestClient.swift
//  SocialMediaTests
//
//  Created by Eduardo Dias on 16/07/21.
//

import Combine
import Foundation
@testable import social_media

class MockRestClient: RestClient {
    
    private var jsonString: String
    
    private var statusCode: Int
    
    init(jsonString: String, statusCode: Int = 200) {
        self.jsonString = jsonString
        self.statusCode = statusCode
    }
    
    func performRequest(_ request: URLRequest) -> AnyPublisher<RequestResult, URLError> {
        
        let response = HTTPURLResponse(url: request.url!, statusCode: statusCode, httpVersion: "1.0", headerFields: [:])!
        
        let result = (data: Data(jsonString.utf8), response: response)
        
        return Just(result)
            .setFailureType(to: URLError.self)
            .eraseToAnyPublisher()
    }
}
