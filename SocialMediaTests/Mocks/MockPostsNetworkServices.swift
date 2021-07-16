//
//  MockPostsNetworkService.swift
//  SocialMediaTests
//
//  Created by Eduardo Dias on 16/07/21.
//

import Foundation
@testable import social_media

class MockPostsNetworkServices: PostsNetworkServices {
    var jsonString: String = ""
    var statusCode: Int = 200
    override var restClient: RestClient { MockRestClient(jsonString: jsonString, statusCode: statusCode) }
}
