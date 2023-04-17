//
//  CoverImageView.swift
//  LibraryTestTask
//
//  Created by Artem Sulzhenko on 14.04.2023.
//

import UIKit

class CoverImageView: UIImageView {
    
    func fetchImage(with url: String?) {
        guard let url else { return }
        guard let imageUrl = URL(string: url) else {
            image = UIImage(named: "NoCover")
            return
        }

        if let cachedImage = getCachedImage(url: imageUrl) {
            image = cachedImage
            return
        }

        URLSession.shared.dataTask(with: imageUrl) { data, response, error in

            if let error { print(error); return }
            guard let data, let response else { return }
            guard let responseURL = response.url else { return }

            if responseURL.absoluteString != url { return }

            DispatchQueue.main.async {
                self.image = UIImage(data: data)
            }

            self.saveImageToCache(data: data, response: response)

        }.resume()

    }

    private func saveImageToCache(data: Data, response: URLResponse) {
        guard let responseURL = response.url else { return }
        let cashedResponse = CachedURLResponse(response: response, data: data)
        URLCache.shared.storeCachedResponse(cashedResponse, for: URLRequest(url: responseURL))

    }

    private func getCachedImage(url: URL) -> UIImage? {
        if let cacheResponse = URLCache.shared.cachedResponse(for: URLRequest(url: url)) {
            return UIImage(data: cacheResponse.data)
        }

        return nil
    }
}
