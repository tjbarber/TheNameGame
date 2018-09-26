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
    var member: TeamMember?
    
    init(member: TeamMember) {
        self.member = member
    }
    
    override func main() {
        if self.isCancelled {
            return
        }
        
        guard let member = self.member,
              let imageURLString = member.headshot.url else { return }
        
        let imageURLStringWithScheme = "http:\(imageURLString)"
        guard let imageURL = URL(string: imageURLStringWithScheme) else { return }
        
        if let cachedImage = ImageCache.sharedInstance.get(fileUrl: imageURL) {
            member.headshot.image = cachedImage
            return
        }
        
        if self.isCancelled {
            return
        }
        
        do {
            let imageData = try Data(contentsOf: imageURL)
            guard let image = UIImage(data: imageData) else { return }
            
            ImageCache.sharedInstance.set(fileUrl: imageURL, image: image)
            member.headshot.image = image
        } catch (let e) {
            // set image status
            print(e.localizedDescription)
        }
        
    }
}
