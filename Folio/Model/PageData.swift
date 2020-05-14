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
    var pageViewSize =  CGSize()
    var lasteDateOfEditting = Date()
    var bigCards = [bigCardData]()
    var smallCards = [smallCardData]()
    var mediaCards = [mediaCardData]()
    var conntectedViews = [connectingViewTupple]()
    
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

struct bigCardData: Codable {
    var card = Card()
    var frame = CGRect.zero
}
struct smallCardData: Codable {
    var card = SmallCard()
    var frame = CGRect.zero
}
struct mediaCardData: Codable{
    var card = MediaCard()
    var frame = CGRect.zero
}
