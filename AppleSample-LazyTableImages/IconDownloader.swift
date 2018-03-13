//
//  IconDownloader.swift
//  AppleSample-LazyTableImages
//
//  Created by Hamoud Alhoqbani on 3/13/18.
//  Copyright © 2018 Hamoud Alhoqbani. All rights reserved.
//

import UIKit


class IconDownloader {

    var sessionTask: URLSessionDataTask?
    var appRecord: AppRecord
    var appIconSize: CGFloat = 48
    var completionHandler: (() -> Void)?

    init(appRecord: AppRecord) {
        self.appRecord = appRecord
    }


    func startDownload() {

        guard let url = URL(string: appRecord.imageURLString) else {
            return
        }

        self.sessionTask = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in

            guard error == nil else {
                print(error!)
                return
            }

            guard let data = data, let image = UIImage(data: data) else {
                return
            }

            OperationQueue.main.addOperation { [weak self] in

                guard let strongSelf = self else {
                    return
                }

                // We need to resize the image to fit appIconSize
                if image.size.width != strongSelf.appIconSize || image.size.height != strongSelf.appIconSize {

                    let itemSize: CGSize = CGSize(width: strongSelf.appIconSize, height: strongSelf.appIconSize)
                    UIGraphicsBeginImageContextWithOptions(itemSize, false, 0)
                    let imageRect = CGRect(x: 0, y: 0, width: strongSelf.appIconSize, height: strongSelf.appIconSize)
                    image.draw(in: imageRect)
                    strongSelf.appRecord.appIcon = image
                    UIGraphicsEndImageContext()

                } else {
                    strongSelf.appRecord.appIcon = image
                }

                // call our completion handler to tell our client that our icon is ready for display
                strongSelf.completionHandler?()
            }
        })
        
        self.sessionTask?.resume()
    }

    func cancelDownload() {
        self.sessionTask?.cancel()
        self.sessionTask = nil
    }
}
