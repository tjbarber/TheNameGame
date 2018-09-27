//
//  ImageCache.swift
//  NameGame
//
//  Created by TJ Barber on 9/25/18.
//  Copyright © 2018 WillowTree Apps. All rights reserved.
//

import UIKit

class ImageCache {
    static let sharedInstance = ImageCache()
    
    func get(fileUrl: URL) -> UIImage? {
        let fileName = fileUrl.lastPathComponent
        
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let imagePath = "\(documentsPath)/\(fileName)"
        
        if FileManager.default.fileExists(atPath: imagePath) {
            return UIImage(contentsOfFile: imagePath)
        }
        
        return nil
    }
    
    func set(fileUrl: URL, image: UIImage) {
        let fileName = fileUrl.lastPathComponent
        
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let imagePath = "\(documentsPath)/\(fileName)"
        
        if let imageData = image.jpegData(compressionQuality: 1.0) {
            let saveUrl = URL(fileURLWithPath: imagePath)
            do {
                try imageData.write(to: saveUrl)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
