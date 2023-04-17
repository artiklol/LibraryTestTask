//
//  MainViewControllerViewModel.swift
//  LibraryTestTask
//
//  Created by Artem Sulzhenko on 14.04.2023.
//

import Foundation

protocol MainViewControllerViewModelProtocol {
    var books: [Book] { get }
    var statusCode: Int { get }
    func fetchLibrary(completion: @escaping() -> Void)
    func numberOfItems() -> Int
    func cellViewModel(at indexPath: IndexPath) -> LibraryCellViewModelViewModelProtocol
    func selectedCell(for indexPath: IndexPath)
    func viewModelForSelectedCell() -> DetailsBookViewControllerViewModelProtocol?
}

class MainViewControllerViewModel: MainViewControllerViewModelProtocol {

    var books = [Book]()

    var statusCode = Int()

    private var indexPath: IndexPath?

    func numberOfItems() -> Int {
        books.count
    }

    func cellViewModel(at indexPath: IndexPath) -> LibraryCellViewModelViewModelProtocol {
        let book = books[indexPath.row]
        return LibraryCellViewModel(book: book)
    }

    func fetchLibrary(completion: @escaping () -> Void) {
        NetworkManager.fetchBooks { [weak self] books, statusCode in
            if let books { self?.books = books }
            if let statusCode { self?.statusCode = statusCode }
            completion()
        }
    }

    func selectedCell(for indexPath: IndexPath) {
        self.indexPath = indexPath
    }

    func viewModelForSelectedCell() -> DetailsBookViewControllerViewModelProtocol? {
        guard let indexPath else { return nil }
        let book = books[indexPath.row]
        return DetailsBookViewControllerViewModel(book: book)
    }

}
