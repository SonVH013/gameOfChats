//
//  Extension.swift
//  gameOfChats
//
//  Created by GVN on 7/18/18.
//  Copyright © 2018 SONVH. All rights reserved.
//

import Foundation
import UIKit

let imageCache = NSCache<NSString, UIImage>()

extension UIImageView {
    func loadImageUsingCache(urlString: String) {
        self.image = nil
        //check cache
        if let cachedImage = imageCache.object(forKey: urlString as NSString) {
            self.image = cachedImage
        } else {
            let url = URL(string: urlString)
            URLSession.shared.dataTask(with: url!) { (data, response, error) in
                if error != nil {
                    print(error)
                    return
                }
                DispatchQueue.main.async {
                    if let downloadedImg = UIImage(data: data!) {
                        imageCache.setObject(downloadedImg, forKey: urlString as NSString)
                        self.image = downloadedImg
                    }
                }}.resume()
        }
    }
}
