//
//  SerializerTests.swift
//  SocialMediaTests
//
//  Created by Eduardo Dias on 16/07/21.
//

import Combine
import XCTest
@testable import social_media

class SerializerTests: XCTestCase {

    func test_dataIsDeserializedSuccesfully() {
        
        let jsonString = """
        {
        "name": "John",
        "email": "john@gmail.com",
        "phone": 234234232
        }
        """
        
        let person = try? Serializer.shared.deserialize(Person.self, data: Data(jsonString.utf8))
        
        XCTAssertEqual(person?.name, "John")
        XCTAssertEqual(person?.email, "john@gmail.com")
        XCTAssertEqual(person?.phone, 234234232)
    }
    
    func test_listIsDeserializedSuccesfully() {
        
        let jsonString = """
        [{
        "name": "John",
        "email": "john@gmail.com",
        "phone": 234234232
        },
        {"name": "Bianca",
        "email": "bianca@gmail.com",
        "phone": 8767868768
        }]
        """
        
        let people = try? Serializer.shared.deserialize([Person].self, data: Data(jsonString.utf8))
        
        XCTAssertEqual(people?.count, 2)
        
        XCTAssertEqual(people?.first?.name, "John")
        XCTAssertEqual(people?.first?.email, "john@gmail.com")
        XCTAssertEqual(people?.first?.phone, 234234232)
        
        XCTAssertEqual(people?[1].name, "Bianca")
        XCTAssertEqual(people?[1].email, "bianca@gmail.com")
        XCTAssertEqual(people?[1].phone, 8767868768)
    }
    
    func test_dataIsDeserializedSuccesfullyWithEmptyList() {
        
        let jsonString = "[]"
        
        let people = try? Serializer.shared.deserialize([Person].self, data: Data(jsonString.utf8))
        
        XCTAssertEqual(people?.count, 0)
    }

    func test_dataFailsWithMalformedData() throws {
        
        let jsonString = """
        {
        "name": "John",
        "email" "john@gmail.com",
        "phone": 234234232
        }
        """
        
        let person = try? Serializer.shared.deserialize(Person.self, data: Data(jsonString.utf8))
        XCTAssertNil(person)
    }
    
    func test_dataFailsWithIncorrectDataMapping() throws {
        
        let jsonString = """
        {
        "name": "John",
        "address" "548 West Glen Creek St.San Francisco, CA 94112",
        "phone": 234234232
        }
        """
        
        let person = try? Serializer.shared.deserialize(Person.self, data: Data(jsonString.utf8))
        XCTAssertNil(person)
    }
    
    func test_dataFailsWithEmptyData() throws {
        
        let jsonString = ""
        
        let person = try? Serializer.shared.deserialize(Person.self, data: Data(jsonString.utf8))
        XCTAssertNil(person)
    }
}

private struct Person: Decodable {
    let name: String
    let email: String
    let phone: Int
}
