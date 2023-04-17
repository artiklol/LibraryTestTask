//
//  Library.swift
//  LibraryTestTask
//
//  Created by Artem Sulzhenko on 13.04.2023.
//

import UIKit

struct Library: Codable {
    let books: [Book]

    enum CodingKeys: String, CodingKey {
        case books = "works"
    }
}

struct Book: Codable {
    let titleBook: String
    let firstPublishYear: Int
    let coverEditionKey: String?
    var fullUrlCoverImage: String {
        if let coverEditionKey {
            return "https://covers.openlibrary.org/b/olid/\(coverEditionKey)-M.jpg"
        } else {
            return ""
        }
    }

    let key: String
    var ratingFullUrl: String {
        return "https://openlibrary.org\(key)/ratings.json"
    }

    var descriptionFullUrl: String {
        let superkey = key.components(separatedBy: "/works/").last?.components(separatedBy: "").first
        return "https://openlibrary.org/books/\(superkey ?? "").json"
    }

    enum CodingKeys: String, CodingKey {
        case key = "key"
        case titleBook = "title"
        case firstPublishYear = "first_publish_year"
        case coverEditionKey = "cover_edition_key"
    }
}

struct Ratings: Codable {
    let summary: Rating
}

struct Rating: Codable {
    let average: Double
}

struct Description: Codable {
    let description: String?
}

struct DescriptionOne: Codable {
    let description: ValueDescription
}

struct ValueDescription: Codable {
    let value: String?
}
