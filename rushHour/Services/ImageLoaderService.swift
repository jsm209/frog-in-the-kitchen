//
//  ImageLoaderService.swift
//  rushHour
//
//  Created by Maza, Joshua on 1/31/24.
//

import Foundation

// Was used earlier to load images from the internet for testing purposes only.
class ImageLoaderService {
    
    func fetchImage(from urlString: String, completion: @escaping (Data?) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Error fetching the image: \(error)")
                completion(nil)
            } else {
                completion(data)
            }
        }.resume()
    }
    
}
