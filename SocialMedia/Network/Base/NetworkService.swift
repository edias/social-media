//
//  NetworkService.swift
//  social-media
//
//  Created by Eduardo Dias on 12/07/21.
//

import Combine
import Foundation

extension URLSession: RestClient {}

enum NetworkServiceError: Error {
    case invalidURL
}

protocol RestClient {
    func dataTaskPublisher(for request: URLRequest) -> URLSession.DataTaskPublisher
}

protocol RestService {
    var restClient: RestClient { get }
}

protocol NetworkService: RestService {
    func get<ResultData: Decodable>(url: String) -> AnyPublisher<ResultData, Error>
}

extension NetworkService {
    
    func get<ResultData: Decodable>(url: String) -> AnyPublisher<ResultData, Error> {
        
        guard let url = URL(string: url) else {
            return Fail<ResultData, Error>(error: NetworkServiceError.invalidURL).eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        return restClient.dataTaskPublisher(for: request)
            .tryMap { output in try NetworkStatusHandler.handleOutput(output).data }
            .tryMap { output in try Serializer.shared.deserialize(ResultData.self, data: output) }
            .eraseToAnyPublisher()
    }
}
