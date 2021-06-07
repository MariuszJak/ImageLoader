//
//  ImageLoader.swift
//  ImageLoader
//
//  Created by Mariusz Jakowienko on 13/09/2020.
//  Copyright © 2020 Mariusz Jakowienko. All rights reserved.
//

import Combine
import UIKit
import Foundation

public class ImageLoader {
    private static let cache = ImageCache()
    private static let backgroundQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 5
        return queue
    }()
    
    public static func loadImage(from url: URL) -> AnyPublisher<UIImage?, Never> {

        if let image = cache[url] {
            return Just(image).eraseToAnyPublisher()
        }
        return URLSession.shared.dataTaskPublisher(for: url)
            .map { (data, response) -> UIImage? in return UIImage(data: data) }
            .catch { error in return Just(nil) }
            .handleEvents(receiveOutput: { image in
                guard let image = image else { return }
                self.cache[url] = image
            })
            .subscribe(on: backgroundQueue)
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
}
