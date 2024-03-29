//
//  ImageCache.swift
//  ImageLoader
//
//  Created by Mariusz Jakowienko on 13/09/2020.
//  Copyright © 2020 Mariusz Jakowienko. All rights reserved.
//

import Foundation
import UIKit

final class ImageCache {
    lazy var imageCache: NSCache<AnyObject, AnyObject> = {
        let cache = NSCache<AnyObject, AnyObject>()
        cache.countLimit = config.countLimit
        return cache
    }()

    lazy var decodedImageCache: NSCache<AnyObject, AnyObject> = {
        let cache = NSCache<AnyObject, AnyObject>()
        cache.totalCostLimit = config.memoryLimit
        return cache
    }()

    let lock = NSLock()
    let config: Config

    struct Config {
        let countLimit: Int
        let memoryLimit: Int

        static let defaultConfig = Config(countLimit: 100,
                                          memoryLimit: 1024 * 1024 * 100) // 100 MB
    }

    init(config: Config = Config.defaultConfig) {
        self.config = config
    }
}
