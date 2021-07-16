//
//  CommentNetworkServiceTests.swift
//  SocialMediaTests
//
//  Created by Eduardo Dias on 16/07/21.
//

import Combine
import XCTest
@testable import social_media

class CommentsNetworkServiceTests: XCTestCase {

    private var susbcriptions = Set<AnyCancellable>()

    private var mockPostsNetworkServices: MockPostsNetworkServices!
    
    override func setUp() {
        mockPostsNetworkServices = MockPostsNetworkServices()
    }

    func test_commentssReturnsSuccessfully() {
        
        mockPostsNetworkServices.jsonString = """
        [{
        "name": "John",
        "email": "john@gmail.com",
        "body": "Comment Body"
        }]
        """
        
        let expectation = XCTestExpectation(description: "Comments returns successfully")
        
        mockPostsNetworkServices.fetchCommentsFromPost(1).sink { _ in } receiveValue: { comments in
            XCTAssertEqual(comments.count, 1)
            XCTAssertEqual(comments.first?.email, "john@gmail.com")
            expectation.fulfill()
        }.store(in: &susbcriptions)
        
        wait(for: [expectation], timeout: 1)
    }
    
    func test_commentsReturnsWithEmptyList() {
        
        mockPostsNetworkServices.jsonString = "[]"
        
        let expectation = XCTestExpectation(description: "Comments returns with empty list")
        
        mockPostsNetworkServices.fetchCommentsFromPost(1).sink { _ in } receiveValue: { comments in
            XCTAssertTrue(comments.isEmpty)
            expectation.fulfill()
        }.store(in: &susbcriptions)
        
        wait(for: [expectation], timeout: 1)
    }
    
    func test_commentsReturnsFailWithMalformedData() {
        
        mockPostsNetworkServices.jsonString = """
        [{
        "name": "John",
        "email": "john@gmail.com",
        "body": "Comment Body"
        }
        """
        
        let expectation = XCTestExpectation(description: "Comments don't return due to serialization issue with malformed data")
        
        mockPostsNetworkServices.fetchPosts().sink { error in
            switch error {
                case .failure(let error) where error is DecodingError:
                    expectation.fulfill()
                default: break
            }
            
        } receiveValue: { _ in }.store(in: &susbcriptions)
        
        wait(for: [expectation], timeout: 1)
    }
    
    func test_commentsReturnsFailWithEmptyData() {
        
        mockPostsNetworkServices.jsonString = ""
        
        let expectation = XCTestExpectation(description: "Comments don't return due to serialization issue with empty data")
        
        mockPostsNetworkServices.fetchPosts().sink { error in
            switch error {
                case .failure(let error) where error is DecodingError:
                    expectation.fulfill()
                default: break
            }
            
        } receiveValue: { _ in }.store(in: &susbcriptions)
        
        wait(for: [expectation], timeout: 1)
    }
    
    func test_commentsReturnsFailWithErrorStatusCode() {
        
        mockPostsNetworkServices.jsonString = "[]"
        mockPostsNetworkServices.statusCode = 500
        
        let expectation = XCTestExpectation(description: "Comments don't return due to error status code")
        
        mockPostsNetworkServices.fetchPosts().sink { error in
            switch error {
                case .failure(let error as StatusCodeError) where error == StatusCodeError.internalServerError:
                    expectation.fulfill()
                default: break
            }
            
        } receiveValue: { _ in }.store(in: &susbcriptions)
        
        wait(for: [expectation], timeout: 1)
    }

}
