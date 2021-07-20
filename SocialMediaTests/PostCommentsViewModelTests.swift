//
//  PostsCommentsViewModelTests.swift
//  SocialMediaTests
//
//  Created by Eduardo Dias on 16/07/21.
//

import Combine
import XCTest
@testable import social_media

class PostCommentsViewModelTests: XCTestCase {
    
    private var susbcriptions = Set<AnyCancellable>()
    
    private let mockPostsNetworkServices = MockPostsNetworkServices()
    
    override func setUp() {
        susbcriptions = Set<AnyCancellable>()
    }
        
    func test_commentsArePopulatedAfterLoadedSuccesfully() {
        
        mockPostsNetworkServices.jsonString = """
        [{
        "name": "mike",
        "email": "mike@gmail.com",
        "body": "mike content"
        },
        {
        "name": "paul",
        "email": "paul@gmail.com",
        "body": "paul content"
        }]
        """
        
        let expectation = XCTestExpectation(description: "Comments are populated after loaded succesfully")
        
        let vm = PostCommentsViewModel(mockPostsNetworkServices)
        
        vm.$comments.dropFirst(3).sink { posts in
            XCTAssertEqual(posts.count, 2)
            expectation.fulfill()
        }.store(in: &susbcriptions)
        
        vm.loadComments(1)
        
        wait(for: [expectation], timeout: 1)
    }

    func test_commentsLoadedFlagChangeToTrueAfterCommentsAreLoaded() {
        
        mockPostsNetworkServices.jsonString = """
        [{
        "name": "paul",
        "email": "paul@gmail.com",
        "body": "paul content"
        }]
        """
        
        let expectation = XCTestExpectation(description: "Comments loaded flag change to true")
        
        let vm = PostCommentsViewModel(mockPostsNetworkServices)
        
        vm.$commentsLoaded.dropFirst(2).sink { isLoaded in
            XCTAssertTrue(isLoaded)
            expectation.fulfill()
        }.store(in: &susbcriptions)
        
        vm.loadComments(1)
        
        wait(for: [expectation], timeout: 1)
    }
    
    func test_errorTypeIsSetWhenCommentsFailsToLoad() {
        
        mockPostsNetworkServices.jsonString = ""
        
        let expectation = XCTestExpectation(description: "Error type is set when comments fails to load due to an error")
        
        let vm = PostCommentsViewModel(mockPostsNetworkServices)
        
        vm.$errorType.dropFirst().sink { errorType in
            XCTAssertNotNil(errorType)
            XCTAssertEqual(errorType, ErrorType.generic)
            expectation.fulfill()
        }.store(in: &susbcriptions)
        
        vm.loadComments(1)
        
        wait(for: [expectation], timeout: 1)
    }
    
    func test_errorIsSetToNilAfterRetrySuccessfully() {
        
        mockPostsNetworkServices.jsonString = ""
        
        let expectation = XCTestExpectation(description: "Error type is set to nil after retry action loads succesfully")
        
        let vm = PostCommentsViewModel(mockPostsNetworkServices)
        
        let stopTrigger = PassthroughSubject<Void, Never>()
        
        vm.$errorType.dropFirst().prefix(untilOutputFrom: stopTrigger).sink { errorType in
            
            XCTAssertNotNil(errorType)
            XCTAssertEqual(errorType, ErrorType.generic)
            
            self.mockPostsNetworkServices.jsonString = """
            [{
            "name": "paul",
            "email": "paul@gmail.com",
            "body": "paul content"
            }]
            """
            
            //  After receiving an error event the error screen is displaying.
            // Now we stop receiving events from this subscription.
            stopTrigger.send()
            
            // We call this operation once this is what the try again button does
            vm.loadComments(1)

        }.store(in: &susbcriptions)
        
        vm.$errorType.dropFirst(2).sink { errorType in
            XCTAssertNil(errorType)
            expectation.fulfill()
        }.store(in: &susbcriptions)
        
        vm.loadComments(1)
        
        wait(for: [expectation], timeout: 1)
    }

    
    func test_commentsAreFiltered() {
        
        mockPostsNetworkServices.jsonString = """
        [{
        "name": "mike",
        "email": "mike@gmail.com",
        "body": "mike content"
        },
        {
        "name": "paul",
        "email": "paul@gmail.com",
        "body": "paul content"
        }]
        """
        
        let expectation = XCTestExpectation(description: "Comments are filtered by searchText property")
        
        let vm = PostCommentsViewModel(mockPostsNetworkServices)
        
        vm.$comments.dropFirst(4).sink { posts in
            XCTAssertEqual(posts.count, 1)
            XCTAssertEqual(posts.first?.email, "paul@gmail.com")
            expectation.fulfill()
        }.store(in: &susbcriptions)
        
        vm.loadComments(1)
        vm.searchText = "paul"
        
        wait(for: [expectation], timeout: 1)
    }
}
