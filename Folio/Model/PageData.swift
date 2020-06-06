//
//  PageData.swift
//  card2
//
//  Created by Kshitiz Sharma on 20/04/20.
//  Copyright © 2020 Kshitiz Sharma. All rights reserved.
//

import Foundation
import UIKit

struct PageData: Codable{
    var title = "Title"
    var uniqueID = UUID()
    var lasteDateOfEditting = Date()
    var drawingData = Data()
    var bigCards = [bigCardData]()
    var smallCards = [smallCardData]()
    var mediaCards = [mediaCardData]()
    var conntectedViews = [connectingViewTupple]()
    var pageWidth = 0.0
    var pageHeight = 0.0
    
    init(){
    }
    init?(json: Data){
        if let newValue = try? JSONDecoder().decode(PageData.self, from: json) {
            self = newValue
        } else {
            return nil
        }
    }
    init(title: String){
        self.title = title
    }
    
    var json: Data? {
        return try? JSONEncoder().encode(self)
    }
    
    
}
struct connectingViewTupple: Codable{
    var first: UUID?
    var second: UUID?
}
//struct MyReminder {
//    let title: String
//    let date: Date
//    let identifier: String
//}

struct bigCardData: Codable {
    var card = Card()
    var frame = CGRect.zero
    var isHidden=false
}
struct smallCardData: Codable {
    var card = SmallCard()
    var frame = CGRect.zero
    var isHidden=false
}
struct mediaCardData: Codable{
    var card = MediaCard()
    var frame = CGRect.zero
    var isHidden=false
}
