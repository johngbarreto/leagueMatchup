//
//  HomeViewModel.swift
//  leagueMatchup
//
//  Created by João Gabriel Lavareda Ayres Barreto on 08/02/24.
//

import UIKit

protocol HomeViewModelDelegate: AnyObject {
    func success()
    func error()
}

class HomeViewModel {
    
    // MARK: - Declarations
    
    var championData: [ChampionModel] = []
    
    func getChampionData() -> [ChampionModel] {
        return championData
    }
    
    var selectedChampions: [ChampionModel] = []
    
    var searchChamps: [ChampionModel] = []
    
    var filteredChampions: [ChampionModel] = []
    
    weak private var delegate: HomeViewModelDelegate?
    
    public func delegate(delegate: HomeViewModelDelegate) {
        self.delegate = delegate
    }
    
    // MARK: - Requests
    
    func request() {
        API.shared.getAllChampions(completion: { result in
            switch result {
            case .success(let response):
                self.championData = Array(response.data.values).map { championData in
                    let sanitizedChampionName = championData.id.replacingOccurrences(of: " ", with: "")
                    let imageURLString = "https://ddragon.leagueoflegends.com/cdn/14.3.1/img/champion/\(sanitizedChampionName).png"
                    let imageURL = URL(string: imageURLString)
                    return ChampionModel(id: championData.id,
                                         key: championData.key,
                                         name: championData.name,
                                         title: championData.title,
                                         blurb: championData.blurb,
                                         tags: championData.tags,
                                         imageURL: imageURL)
                }
                self.championData.sort { $0.name < $1.name }
                self.delegate?.success()
            case .failure(let error):
                self.delegate?.error()
                print(error)
            }
        })
    }
    
    
    // MARK: - CollectionView
    
    var searchText: String = "" {
           didSet {
               filterChampions()
           }
       }
    
    func filterChampions() {
           if searchText.isEmpty {
               searchChamps = championData
           } else {
               searchChamps = championData.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
           }
       }
    
    func getSelectedIndexPaths(from collectionView: UICollectionView) -> [IndexPath] {
        guard let selectedIndexPaths = collectionView.indexPathsForSelectedItems else {
            return []
        }
        return selectedIndexPaths
    }
    
    var sizerForItemAt: CGSize {
        return CGSize(width: 100, height: 34)
    }
    
    func champion(at index: Int) -> ChampionModel? {
        guard index < championData.count else {
            return nil
        }
        return championData[index]
    }
    
    var numberOfChampions: Int {
        return championData.count
    }
    
}


