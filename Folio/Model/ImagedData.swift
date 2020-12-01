//
//  MediaCardData.swift
//  card2
//
//  Created by Kshitiz Sharma on 05/05/20.
//  Copyright © 2020 Kshitiz Sharma. All rights reserved.
//

import Foundation

struct imageData: Codable{
    var data = Data()
    var json: Data? {
        return try? JSONEncoder().encode(self)
    }
    init(instData: Data){
        self.data=instData
    }
    init?(json: Data){
        if let newValue = try? JSONDecoder().decode(imageData.self, from: json) {
            self = newValue
        } else {
            return nil
        }
    }
}
