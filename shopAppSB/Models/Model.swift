//
//  File.swift
//  shopAppSB
//
//  Created by developer on 5/12/22.
//

import Foundation

struct Item: Codable {
    let name: String
    let price: Double
    let image_link: String
    
    enum CodingKeys: String, CodingKey {
        case price = "price"
        case image_link = "image"
        case name = "title"
    }
    
}



