//
//  MediaCardData.swift
//  card2
//
//  Created by Kshitiz Sharma on 05/05/20.
//  Copyright © 2020 Kshitiz Sharma. All rights reserved.
//

import Foundation

struct MediaCard: Codable {
    var UniquIdentifier: UUID?
//    var data = (Any?, mediaType?)()
    var title: String?
    var dateOfCreation: Date = Date()
//    var data = [AnyObject]()
    var mediaData = [Data]()
    
}

enum mediaType {
    case image
    case video
    case audio
}
