//
//  NetworkStatusHandlerTests.swift
//  SocialMediaTests
//
//  Created by Eduardo Dias on 16/07/21.
//

import Combine
import Foundation
import XCTest
@testable import social_media

class NetworkStatusHandlerTests: XCTestCase {

    func test_outputIsHandledSuccessfully() {
        let response = HTTPURLResponse(url: URL(string: "https://www.google.com")!, statusCode: 200, httpVersion: "1.0", headerFields: [:])!
        let output = (data: Data("test".utf8), response: response)
        let outputData = try? NetworkStatusHandler.handleOutput(output)
        XCTAssertTrue(outputData?.data.isEmpty == false)
        XCTAssertEqual(outputData?.response.url?.absoluteString, "https://www.google.com")
    }
    
    func test_outputThrowsWithInvalidHash() throws {
        
        let response = HTTPURLResponse(url: URL(string: "https://www.google.com")!, statusCode: 401, httpVersion: "1.0", headerFields: [:])!
        let output = (data: Data("test".utf8), response: response)
        
        do {
            let _ = try NetworkStatusHandler.handleOutput(output)
        } catch let error as StatusCodeError {
            XCTAssertEqual(error, StatusCodeError.invalidRefererOrHash)
        }
    }
    
    func test_outputThrowsWithForbidden() throws {
        
        let response = HTTPURLResponse(url: URL(string: "https://www.google.com")!, statusCode: 403, httpVersion: "1.0", headerFields: [:])!
        let output = (data: Data("test".utf8), response: response)
        
        do {
            let _ = try NetworkStatusHandler.handleOutput(output)
        } catch let error as StatusCodeError {
            XCTAssertEqual(error, StatusCodeError.forbidden)
        }
    }
    
    func test_outputThrowsWithMethodNotAllowed() throws {
        
        let response = HTTPURLResponse(url: URL(string: "https://www.google.com")!, statusCode: 405, httpVersion: "1.0", headerFields: [:])!
        let output = (data: Data("test".utf8), response: response)
        
        do {
            let _ = try NetworkStatusHandler.handleOutput(output)
        } catch let error as StatusCodeError {
            XCTAssertEqual(error, StatusCodeError.methodNotAllowed)
        }
    }
    
    func test_outputThrowsWithMissingApiKeyHashOrTimestamp() throws {
        
        let response = HTTPURLResponse(url: URL(string: "https://www.google.com")!, statusCode: 409, httpVersion: "1.0", headerFields: [:])!
        let output = (data: Data("test".utf8), response: response)
        
        do {
            let _ = try NetworkStatusHandler.handleOutput(output)
        } catch let error as StatusCodeError {
            XCTAssertEqual(error, StatusCodeError.missingApiKeyHashOrTimestamp)
        }
    }
    
    func test_outputThrowsWithInternalServerError() throws {
        let response = HTTPURLResponse(url: URL(string: "https://www.google.com")!, statusCode: 500, httpVersion: "1.0", headerFields: [:])!
        let output = (data: Data("test".utf8), response: response)
        
        do {
            let _ = try NetworkStatusHandler.handleOutput(output)
        } catch let error as StatusCodeError {
            XCTAssertEqual(error, StatusCodeError.internalServerError)
        }
    }
    
    func test_outputThrowsWithUnknown() throws {
        let response = HTTPURLResponse(url: URL(string: "https://www.google.com")!, statusCode: 999, httpVersion: "1.0", headerFields: [:])!
        let output = (data: Data("test".utf8), response: response)
        
        do {
            let _ = try NetworkStatusHandler.handleOutput(output)
        } catch let error as StatusCodeError {
            XCTAssertEqual(error, StatusCodeError.unknownError)
        }
    }
}
