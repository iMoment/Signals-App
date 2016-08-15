//
//  Extensions.swift
//  Signals
//
//  Created by Stanley Pan on 8/16/16.
//  Copyright © 2016 Stanley Pan. All rights reserved.

import UIKit

let imageCache = NSCache()

extension UIImageView {
    
    func loadImageUsingCacheWithUrlString(urlString: String) {
        
        // TODO: Check cache for image first
        
        
        let url = NSURL(string: urlString)
        NSURLSession.sharedSession().dataTaskWithURL(url!, completionHandler: { (data, response, error) in
            
            if error != nil {
                print(error)
                return
            }
            
            dispatch_async(dispatch_get_main_queue(), {
                
                if let downloadedImage = UIImage(data: data!) {
                    imageCache.setObject(downloadedImage, forKey: urlString)
                    
                    self.image = downloadedImage
                }
            })
            
        }).resume()
    }
}