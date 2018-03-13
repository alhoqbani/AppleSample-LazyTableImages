//
//  AppRecord.swift
//  AppleSample-LazyTableImages
//
//  Created by Hamoud Alhoqbani on 3/13/18.
//  Copyright © 2018 Hamoud Alhoqbani. All rights reserved.
//

import UIKit

//: MARK:  Main AppRecord Model
struct AppRecord {
    
    var appName: String
    var imageURLString: String
    var appIcon: UIImage?
    
    init(appName: String, imageURLString: String) {
        self.appName = appName
        self.imageURLString = imageURLString
    }
}


//: MARK: Intermediary helpers structs to parse JSON response
struct FeedResponse: Decodable {
    
    var feed: Feed
    
    struct Feed: Decodable {
        var entry: [Entry]
    }
    
    struct Entry: Decodable {
        var nameWrapper: Name
        var Images: [Image]

        struct Image: Decodable {
            var label: String
        }

        private enum CodingKeys: String, CodingKey {
            case nameWrapper = "im:name"
            case Images = "im:image"
        }
        
        struct Name: Decodable {
            var label: String
        }
    }
}

struct AppsFeed {
    var records: [Record]
    init(records: [Record]) {
        self.records = records
    }
    struct Record: Decodable {
        var appName: String
        var imageURLString: String
    }
}

extension AppsFeed: Decodable {

    public init(from decoder: Decoder) throws {
        var records = [Record]()
        let feedResponse = try FeedResponse(from: decoder)

        feedResponse.feed.entry.forEach { (entry) in
            
            let name = entry.nameWrapper.label
            let imageUrl = entry.Images.first?.label
            
            let record = Record(appName: name, imageURLString: imageUrl ?? "")
            records.append(record)
        }
        
        self.init(records: records)
    }
}
