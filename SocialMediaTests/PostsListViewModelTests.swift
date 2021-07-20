//
//  PostCommentsViewModelTests.swift
//  SocialMediaTests
//
//  Created by Eduardo Dias on 16/07/21.
//

import Combine
import XCTest
@testable import social_media

class PostsListViewModelTests: XCTestCase {
    
    private var susbcriptions = Set<AnyCancellable>()
    
    private let mockPostsNetworkServices = MockPostsNetworkServices()
    
    override func setUp() {
        susbcriptions = Set<AnyCancellable>()
    }
        
    func test_postsArePopulatedAfterLoadedSuccesfully() {
        
        mockPostsNetworkServices.jsonString = """
        [{
        "userId": 1,
        "id": 99,
        "title": "User Title",
        "body": "User Body"
        },
        {
        "userId": 2,
        "id": 3423,
        "title": "User Title2",
        "body": "User Body2"
        }]
        """
        
        let expectation = XCTestExpectation(description: "Posts are populated after loaded succesfully")
        
        let vm = PostsListViewModel(mockPostsNetworkServices)
        
        vm.$posts.dropFirst(3).sink { posts in
            XCTAssertEqual(posts.count, 2)
            expectation.fulfill()
        }.store(in: &susbcriptions)
        
        vm.loadPosts()
        
        wait(for: [expectation], timeout: 1)
    }

    func test_postsLoadedFlagChangeToTrueAfterPostsAreLoaded() {
        
        mockPostsNetworkServices.jsonString = """
        [{
        "userId": 1,
        "id": 99,
        "title": "User Title",
        "body": "User Body"
        }]
        """
        
        let expectation = XCTestExpectation(description: "Posts loaded flag change to true")
        
        let vm = PostsListViewModel(mockPostsNetworkServices)
        
        vm.$postsLoaded.dropFirst(2).sink { isLoaded in
            XCTAssertTrue(isLoaded)
            expectation.fulfill()
        }.store(in: &susbcriptions)
        
        vm.loadPosts()
        
        wait(for: [expectation], timeout: 1)
    }
    
    func test_errorTypeIsSetWhenPostsFailsToLoad() {
        
        mockPostsNetworkServices.jsonString = ""
        
        let expectation = XCTestExpectation(description: "Error type is set when posts fails to load due to an error")
        
        let vm = PostsListViewModel(mockPostsNetworkServices)
        
        vm.$errorType.dropFirst().sink { errorType in
            XCTAssertNotNil(errorType)
            XCTAssertEqual(errorType, ErrorType.generic)
            expectation.fulfill()
        }.store(in: &susbcriptions)
        
        vm.loadPosts()
        
        wait(for: [expectation], timeout: 1)
    }
    
    func test_errorIsSetToNilAfterRetrySuccessfully() {
        
        mockPostsNetworkServices.jsonString = ""
        
        let expectation = XCTestExpectation(description: "Error type is set to nil after retry action loads succesfully")
        
        let vm = PostsListViewModel(mockPostsNetworkServices)
        
        let stopTrigger = PassthroughSubject<Void, Never>()
        
        vm.$errorType.dropFirst().prefix(untilOutputFrom: stopTrigger).sink { errorType in
            
            XCTAssertNotNil(errorType)
            XCTAssertEqual(errorType, ErrorType.generic)
            
            self.mockPostsNetworkServices.jsonString = """
            [{
            "userId": 1,
            "id": 99,
            "title": "User Title",
            "body": "User Body"
            }]
            """
            
            //  After receiving an error event the error screen is displaying.
            // Now we stop receiving events from this subscription.
            stopTrigger.send()
            
            // We call this operation once this is what the try again button does
            vm.loadPosts()

        }.store(in: &susbcriptions)
        
        vm.$errorType.dropFirst(2).sink { errorType in
            XCTAssertNil(errorType)
            expectation.fulfill()
        }.store(in: &susbcriptions)
        
        vm.loadPosts()
        
        wait(for: [expectation], timeout: 1)
    }
    
    func test_postsAreFiltered() {
        
        mockPostsNetworkServices.jsonString = """
        [{
        "userId": 1,
        "id": 99,
        "title": "User Title",
        "body": "User Body"
        },
        {
        "userId": 2,
        "id": 3423,
        "title": "User Title2",
        "body": "User Body2"
        }]
        """
        
        let expectation = XCTestExpectation(description: "Posts are filtered by searchText property")
        
        let vm = PostsListViewModel(mockPostsNetworkServices)
        
        vm.$posts.dropFirst(4).sink { posts in
            XCTAssertEqual(posts.count, 1)
            XCTAssertEqual(posts.first?.id, 3423)
            expectation.fulfill()
        }.store(in: &susbcriptions)
        
        vm.loadPosts()
        vm.searchText = "User Title2"
        
        wait(for: [expectation], timeout: 1)
    }
}
