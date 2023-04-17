//
//  DetailsBookViewControllerViewModel.swift
//  LibraryTestTask
//
//  Created by Artem Sulzhenko on 14.04.2023.
//

import Foundation

protocol DetailsBookViewControllerViewModelProtocol {
    var fullUrlCoverImage: String { get }
    var titleBook: String { get }
    var publishDate: String { get }
    var rating: String? { get }
    var ratingStatusCode: Int? { get }
    var description: String? { get }
    var descriptionStatusCode: Int? { get }
    func fetchRating(completion: @escaping () -> Void)
    func fetchDescription(completion: @escaping () -> Void)
    init(book: Book)
}

class DetailsBookViewControllerViewModel: DetailsBookViewControllerViewModelProtocol {

    private var book: Book

    var fullUrlCoverImage: String {
        return book.fullUrlCoverImage
    }

    var titleBook: String {
        return book.titleBook
    }

    var publishDate: String {
        return "Year of release: \(book.firstPublishYear)"
    }

    var rating: String? = "sdsds"
    var ratingStatusCode: Int?

    var description: String?
    var descriptionStatusCode: Int?
    
    func fetchDescription(completion: @escaping () -> Void) {
        NetworkManager.fethDescription(url: book.descriptionFullUrl) { [weak self] description, statusCode in
            if let description { self?.description = description }
            if let statusCode { self?.descriptionStatusCode = statusCode }
            completion()
        }
    }

    func fetchRating(completion: @escaping () -> Void) {
        NetworkManager.fetchRaiting(url: book.ratingFullUrl) { [weak self] rating, statusCode in
            if let rating { self?.rating = "Rating: \(NSString(format:"%.2f", rating))/5" }
            if let statusCode { self?.ratingStatusCode = statusCode }
            completion()
        }
    }

    required init(book: Book) {
        self.book = book
    }
}
