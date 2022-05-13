//
//  File.swift
//  shopAppSB
//
//  Created by developer on 5/12/22.
//
import UIKit
import Foundation


let itemStr = "https://makeup-api.herokuapp.com/api/v1/products.json"

struct Webservice {
    
    func getItems(completion: @escaping ([Item]) -> Void) {
        guard let url = URL(string: itemStr) else {
            print("invalid url")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("no data, networking error")
                return
            }
            
            guard
                let httpResonse = response as? HTTPURLResponse,
                httpResonse.statusCode == 200
            else {
                print("http status code error")
                return
            }
            do {
                let feed = try JSONDecoder().decode([Item].self, from: data)
                let items = feed
                completion(items)
            } catch {
                // decoding error
                print("parsing error")
                print(error)
            }
        }.resume()
    }
    
    func getImage(imageUrl: String, completion: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: imageUrl) else {
            print("invalid url")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("no data, networking error")
                return
            }
            
            guard
                let httpResonse = response as? HTTPURLResponse,
                httpResonse.statusCode == 200
            else {
                print("http status code error")
                return
            }
            if let image = UIImage(data: data) {
                completion(image)
            } else {
                completion(nil)
            }
        }.resume()
    }
}


