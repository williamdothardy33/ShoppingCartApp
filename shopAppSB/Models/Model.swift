//
//  File.swift
//  shopAppSB
//
//  Created by developer on 5/12/22.
//

import Foundation


struct Feed: Codable {
    let results: [Item]
}


struct Item: Codable {
    let name: String?
    let price: String?
    let image_link: String?
}



