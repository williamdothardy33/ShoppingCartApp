//
//  File.swift
//  shopAppSB
//
//  Created by developer on 5/12/22.
//
import UIKit
import Foundation


let itemStr = "https://fakestoreapi.com/products"

class Webservice {
    static var shared = Webservice()
    private init() { }
    var cache = NSCache<NSString, NSData>()
    
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
    
    func getImage(imageUrl: String, completion: @escaping (Data?) -> Void) {
        
        if let imageData = cache.object(forKey: imageUrl as NSString) {
            completion(imageData as Data)
            return
        }
        
        guard let url = URL(string: imageUrl) else {
            print("invalid url")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            guard
                let httpResonse = response as? HTTPURLResponse,
                httpResonse.statusCode == 200
            else {
                print("http status code error")
                return
            }
            
            guard let data = data, error == nil else {
                print("no data, networking error")
                return
            }
            
            
            self.cache.setObject(data as NSData, forKey: imageUrl as NSString)
            
            completion(data)
            
        }.resume()
    }
}


