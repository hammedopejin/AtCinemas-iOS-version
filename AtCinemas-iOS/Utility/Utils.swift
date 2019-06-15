//
//  Utils.swift
//  AtCinemas-iOS
//
//  Created by Hammed opejin on 6/12/19.
//  Copyright © 2019 Hammed opejin. All rights reserved.
//

import UIKit

struct Utils {
    
    //MARK: FileManager
    static private let fileManager = FileManager.default
    
    //MARK: Save FM
    static func saveWithFileManager(_ data: Data) {
        
        let hash = String("data.hashValue")
        
        guard let url = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent(hash) else {
            
            print("Error with file system")
            return
        }
        
        do {
            try data.write(to: url)
            print("Successfully wrote data to disk")
        } catch {
            print(error.localizedDescription)
        }
    }
    
    //MARK: Load FM
    static func loadWithFileManager(_ hashValue: String) -> URL? {
        
        let documentDirectory = FileManager.SearchPathDirectory.documentDirectory
        let userDomain = FileManager.SearchPathDomainMask.userDomainMask
        let paths = NSSearchPathForDirectoriesInDomains(documentDirectory, userDomain, true)
        
        if let dirPath = paths.first {
            
            let url = URL(fileURLWithPath: dirPath).appendingPathComponent(hashValue)
            
            return url
        }
        
        return nil
    }
    
    static func lockOrientation(_ orientation: UIInterfaceOrientationMask) {
        
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            delegate.orientationLock = orientation
        }
    }
    
    /// OPTIONAL Added method to adjust lock and rotate to the desired orientation
    static func lockOrientation(_ orientation: UIInterfaceOrientationMask, andRotateTo rotateOrientation:UIInterfaceOrientation) {
        
        self.lockOrientation(orientation)
        
        UIDevice.current.setValue(rotateOrientation.rawValue, forKey: "orientation")
        UINavigationController.attemptRotationToDeviceOrientation()
    }

}

func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
    let size = image.size
    
    let widthRatio  = targetSize.width  / size.width
    let heightRatio = targetSize.height / size.height
    
    // Figure out what our orientation is, and use that to form the rectangle
    var newSize: CGSize
    if(widthRatio > heightRatio) {
        newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
    } else {
        newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
    }
    
    // This is the rect that we've calculated out and this is what is actually used below
    let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
    
    // Actually do the resizing to the rect using the ImageContext stuff
    UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
    image.draw(in: rect)
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsGetCurrentContext()?.interpolationQuality = .high
    
    return newImage!
}

