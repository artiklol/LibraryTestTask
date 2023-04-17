//
//  LibraryCellViewModel.swift
//  LibraryTestTask
//
//  Created by Artem Sulzhenko on 14.04.2023.
//

import Foundation

protocol LibraryCellViewModelViewModelProtocol {
    var titleBook: String { get }
    var publishDate: String { get }
    var fullUrlCoverImage: String { get }
    init(book: Book)
}

class LibraryCellViewModel: LibraryCellViewModelViewModelProtocol {

    var titleBook: String {
        return book.titleBook
    }

    var publishDate: String {
        return "\(book.firstPublishYear)"
    }

    var fullUrlCoverImage: String {
        return book.fullUrlCoverImage
    }

    private let book: Book

    required init(book: Book) {
        self.book = book
    }

}
