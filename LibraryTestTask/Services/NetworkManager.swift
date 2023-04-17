//
//  NetworkManager.swift
//  LibraryTestTask
//
//  Created by Artem Sulzhenko on 13.04.2023.
//

import UIKit

class NetworkManager {

    static private let urlLibrary = "https://openlibrary.org/trending/daily.json"

    static func fetchBooks(completion: @escaping ([Book]?, Int?) -> Void) {
        guard let url = URL(string: urlLibrary) else { return }

        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error {
                print(error.localizedDescription)
                return
            }

            guard let response = response as? HTTPURLResponse else { return }

            if response.statusCode >= 200 && response.statusCode < 300 {
                guard let data else { return }
                guard let result = try? JSONDecoder().decode(Library.self, from: data) else { return }

                DispatchQueue.main.async {
                    completion(result.books, nil)
                }
            } else {
                DispatchQueue.main.async {
                    completion(nil, response.statusCode)
                }
                return
            }
        }.resume()
    }

    static func fetchRaiting(url: String, completion: @escaping (Double?, Int?) -> Void) {
        guard let url = URL(string: url) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error {
                print(error.localizedDescription)
                return
            }
            
            guard let response = response as? HTTPURLResponse else { return }

            if response.statusCode >= 200 && response.statusCode < 300 {
                guard let data else { return }
                guard let result = try? JSONDecoder().decode(Ratings.self, from: data) else { return }

                DispatchQueue.main.async {
                    completion(result.summary.average, nil)
                }
            } else {
                DispatchQueue.main.async {
                    completion(nil, response.statusCode)
                }
                return
            }
        }.resume()
    }

    static func fethDescription(url: String, completion: @escaping (String?, Int?) -> Void) {
        guard let url = URL(string: url) else { return }

        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error {
                print(error.localizedDescription)
                return
            }

            guard let response = response as? HTTPURLResponse else { return }

            if response.statusCode >= 200 && response.statusCode < 300 {
                guard let data else { return }

                if let result = try? JSONDecoder().decode(Description.self, from: data) {
                    DispatchQueue.main.async {
                        completion(result.description ?? "There is no description", nil)
                    }
                } else if let result = try? JSONDecoder().decode(DescriptionOne.self, from: data) {
                    DispatchQueue.main.async {
                        completion(result.description.value ?? "There is no description", nil)
                    }
                } else {
                    return
                }
            } else {
                DispatchQueue.main.async {
                    completion(nil, response.statusCode)
                }
                return
            }
        }.resume()
    }
}
