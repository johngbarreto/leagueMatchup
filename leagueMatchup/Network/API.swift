//
//  API.swift
//  leagueMatchup
//
//  Created by João Gabriel Lavareda Ayres Barreto on 01/02/24.
//
import UIKit

class API {
    
    let cache = NSCache<NSString, UIImage>()
    
    static let shared = API()
    private let baseURL = "https://ddragon.leagueoflegends.com/cdn/14.3.1/"
    
    private init() { }
    
    func getAllChampions(completion: @escaping (Result<ChampionResponse, ErrorMessage>) -> Void) {
        
        let endpoint = baseURL + "data/en_US/champion.json"
        
        guard let url = URL(string: endpoint) else {
            completion(.failure(.championError))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let _ = error {
                completion(.failure(.networkError))
                return
            }
            
            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }
            do {
                let decodedData = try JSONDecoder().decode(ChampionResponse.self, from: data)
                
                completion(.success(decodedData))
            } catch {
                completion(.failure(.decodingError))
            }
        }.resume()
    }
    
    
    
}
