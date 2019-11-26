//
//  MixedContentTests.swift
//  XMLCoderTests
//
//  Created by Christopher Williams on 11/21/19.
//

import Foundation

import XCTest
@testable import XMLCoder

class MixedContentTests: XCTestCase {
    
    enum TextItem: Codable, Equatable {
        case br
        case text(String)
        
        enum CodingKeys: String, XMLChoiceCodingKey {
            case br
            case text = "#PCDATA"
        }
        
        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            switch self {
            case .text(let text):
                try container.encode(text, forKey: .text)
            case .br:
                try container.encodeNil(forKey: .br)
            }
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let key = container.allKeys.first!
            switch key {
            case .br:
                self = .br
            case .text:
                let string = try container.decode(String.self, forKey: .text)
                self = .text(string)
            }
            
        }
        
    }

    func testMixed() throws {
        let decoder = XMLDecoder()
        
        let xmlString =
            """
            <container>first<br/>second</container>
            """
        
        let xmlData = xmlString.data(using: .utf8)!

//        let decoded = try decoder.decode([TextItem].self, from: xmlData)
//        XCTAssertEqual(decoded, [.text("first"), .br, .text("second")])
    }

}
