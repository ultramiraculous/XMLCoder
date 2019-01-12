//
//  EnumTests.swift
//  XMLCoderTests
//
//  Created by Max Desiatov on 12/01/2019.
//

import XCTest
@testable import XMLCoder

private enum AB: Decodable, Equatable {
    struct A: Decodable, Equatable { let value: Int }
    struct B: Decodable, Equatable { let value: String }
    case a(A)
    case b(B)

    enum CodingKeys: CodingKey { case a, b }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        do {
            self = .a(try container.decode(A.self, forKey: .a))
        } catch {
            self = .b(try container.decode(B.self, forKey: .b))
        }
    }
}

class EnumTests: XCTestCase {
    func testEnum() throws {
        let xml = """
        <?xml version="1.0" encoding="UTF-8"?>
        <container>
            <a value="42"></a>
            <b value="forty-two"></b>
        </container>
        """.data(using: .utf8)!

        let decoder = XMLDecoder()

        let decoded = try! decoder.decode([AB].self, from: xml)
        let expected: [AB] = [.a(AB.A(value: 42)), .b(AB.B(value: "forty-two"))]

        XCTAssertEqual(decoded, expected)
    }
}
