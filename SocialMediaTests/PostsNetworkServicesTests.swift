//
//  PostsNetworkServicesTests.swift
//  SocialMediaTests
//
//  Created by Eduardo Dias on 16/07/21.
//

import Combine
import XCTest
@testable import social_media

class PostsNetworkServicesTests: XCTestCase {
    
    private var susbcriptions = Set<AnyCancellable>()

    private var mockPostsNetworkServices: MockPostsNetworkServices!
    
    override func setUp() {
        mockPostsNetworkServices = MockPostsNetworkServices()
    }

    func test_postsReturnsSuccessfully() {
        
        mockPostsNetworkServices.jsonString = """
        [{
        "userId": 1,
        "id": 99,
        "title": "User Title",
        "body": "User Body"
        }]
        """
        
        let expectation = XCTestExpectation(description: "Posts returns successfully")
        
        mockPostsNetworkServices.fetchPosts().sink { _ in } receiveValue: { posts in
            XCTAssertEqual(posts.count, 1)
            XCTAssertEqual(posts.first?.title, "User Title")
            expectation.fulfill()
        }.store(in: &susbcriptions)
        
        wait(for: [expectation], timeout: 1)
    }
    
    func test_postsReturnsWithEmptyList() {
        
        mockPostsNetworkServices.jsonString = "[]"
        
        let expectation = XCTestExpectation(description: "Posts returns with empty list")
        
        mockPostsNetworkServices.fetchPosts().sink { _ in } receiveValue: { posts in
            XCTAssertTrue(posts.isEmpty)
            expectation.fulfill()
        }.store(in: &susbcriptions)
        
        wait(for: [expectation], timeout: 1)
    }
    
    func test_postsReturnsFailWithMalformedData() {
        
        mockPostsNetworkServices.jsonString = """
        [{
        "userId: 1,
        "id": 99,
        "title": "User Title",
        "body": "User Body"
        }]
        """
        
        let expectation = XCTestExpectation(description: "Posts don't return due to serialization issue with malformed data")
        
        mockPostsNetworkServices.fetchPosts().sink { error in
            switch error {
                case .failure(let error) where error is DecodingError:
                    expectation.fulfill()
                default: break
            }
            
        } receiveValue: { _ in }.store(in: &susbcriptions)
        
        wait(for: [expectation], timeout: 1)
    }
    
    func test_postsReturnsFailWithEmptyData() {
        
        mockPostsNetworkServices.jsonString = ""
        
        let expectation = XCTestExpectation(description: "Posts don't return due to serialization issue with empty data")
        
        mockPostsNetworkServices.fetchPosts().sink { error in
            switch error {
                case .failure(let error) where error is DecodingError:
                    expectation.fulfill()
                default: break
            }
            
        } receiveValue: { _ in }.store(in: &susbcriptions)
        
        wait(for: [expectation], timeout: 1)
    }
    
    func test_postsReturnsFailWithErrorStatusCode() {
        
        mockPostsNetworkServices.jsonString = "[]"
        mockPostsNetworkServices.statusCode = 500
        
        let expectation = XCTestExpectation(description: "Posts don't return due to error status code")
        
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
