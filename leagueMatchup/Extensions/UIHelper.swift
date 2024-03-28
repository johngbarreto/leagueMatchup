//
//  UIHelper.swift
//  leagueMatchup
//
//  Created by João Gabriel Lavareda Ayres Barreto on 05/02/24.
//

import UIKit

struct UIHelper {
    
    static func configureFlowLayout(in view: UIView) -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 20
        let itemWidth = (UIScreen.main.bounds.width - 48 - 20) / 4
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        layout.scrollDirection = .vertical
        return layout
    }
    
}

extension String {
    
    func StringToDouble(_ str: String) -> Bool {
       return Double(str) != nil
    }
    
    
    var isNumeric: Bool {
        Double(self) != nil
    }
    
    func isGreatorThan(_ value: Double) -> Bool {
        
        guard self.isNumeric else {
            return false
        }
        
        return Double(self)! > value
    }
    
}

class ImageLoader {
    
    let cache = NSCache<NSString, UIImage>()
    let session = URLSession.shared
    
    func loadImage(from urlString: String, completion: @escaping (Result<UIImage, Error>) -> Void) {
        let cacheKey = NSString(string: urlString)
        
        if let cachedImage = cache.object(forKey: cacheKey) {
            completion(.success(cachedImage))
            return
        }
        
        guard let url = URL(string: urlString) else {
            completion(.failure(ImageLoaderError.invalidURL))
            return
        }
        
        let task = session.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self else { return }
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                completion(.failure(ImageLoaderError.invalidResponse))
                return
            }
            
            guard let data = data, let image = UIImage(data: data) else {
                completion(.failure(ImageLoaderError.invalidData))
                return
            }
            
            self.cache.setObject(image, forKey: cacheKey)
            completion(.success(image))
        }
        
        task.resume()
    }
}

enum ImageLoaderError: Error {
    case invalidURL
    case invalidResponse
    case invalidData
}
