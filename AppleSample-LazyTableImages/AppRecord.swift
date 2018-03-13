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
    var artist: String
    var appIcon: UIImage?
    
    init(appName: String, artist: String, imageURLString: String) {
        self.appName = appName
        self.artist = artist
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
        var artistWrapper: Artist
        var Images: [Image]

        struct Image: Decodable {
            var label: String
        }

        private enum CodingKeys: String, CodingKey {
            case nameWrapper = "im:name"
            case artistWrapper = "im:artist"
            case Images = "im:image"
        }

        struct Artist: Decodable {
            var label: String
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
        var artist: String
    }
}

extension AppsFeed: Decodable {

    public init(from decoder: Decoder) throws {
        var records = [Record]()
        let feedResponse = try FeedResponse(from: decoder)

        feedResponse.feed.entry.forEach { (entry) in
            
            let name = entry.nameWrapper.label
            let imageUrl = entry.Images.first?.label
            let artist = entry.artistWrapper.label
            
            let record = Record(appName: name, imageURLString: imageUrl ?? "", artist: artist)
            records.append(record)
        }
        
        self.init(records: records)
    }
}
