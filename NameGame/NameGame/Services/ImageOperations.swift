//
//  ImageOperations.swift
//  NameGame
//
//  Created by TJ Barber on 9/25/18.
//  Copyright © 2018 WillowTree Apps. All rights reserved.
//

import UIKit

class ImageOperations {
    static let sharedInstance = ImageOperations()
    
    lazy var downloadsInProgress = [String: Operation]()
    lazy var downloadQueue: OperationQueue = {
        var queue = OperationQueue()
        queue.name = "Image Operation Queue"
        return queue
    }()
    
    private init() {
        downloadQueue.maxConcurrentOperationCount = 2
    }
}

class ImageDownloader: Operation {
    var headshotImage: HeadshotImage?
    
    init(headshotImage: HeadshotImage) {
        self.headshotImage = headshotImage
    }
    
    override func main() {
        if self.isCancelled {
            return
        }
        
        guard let headshotImage = self.headshotImage else { return }
        guard let imageURLString = headshotImage.imageURLString else {
            headshotImage.image = #imageLiteral(resourceName: "WTPlaceholder")
            return
        }
        
        let imageURLStringWithScheme = "http:\(imageURLString)"
        guard let imageURL = URL(string: imageURLStringWithScheme) else { return }
        
        if let cachedImage = ImageCache.sharedInstance.get(fileUrl: imageURL) {
            headshotImage.image = cachedImage
            return
        }
        
        if self.isCancelled {
            return
        }
        
        do {
            let imageData = try Data(contentsOf: imageURL)
            guard let image = UIImage(data: imageData) else { return }
            
            ImageCache.sharedInstance.set(fileUrl: imageURL, image: image)
            headshotImage.image = image
        } catch (let e) {
            // set image status
            print(e.localizedDescription)
        }
        
    }
}
