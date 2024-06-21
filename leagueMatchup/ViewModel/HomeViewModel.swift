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

    private var championData: [ChampionModel] = []
    private var filteredChampionData: [ChampionModel] = []
    private var selectedChampions: [ChampionModel] = []

    weak var delegate: HomeViewModelDelegate?

     private func createChampionModel(from champion: ChampionModel) -> ChampionModel {
         var updatedChampion = champion
         let sanitizedChampionName = champion.id.replacingOccurrences(of: " ", with: "")
         let imageURLString = "\(API.shared.baseURL)/img/champion/\(sanitizedChampionName).png"
         updatedChampion.imageURL = URL(string: imageURLString)
         return updatedChampion
     }

     private func handleSuccessResponse(_ response: ChampionResponse) {
         self.championData = response.data.values.map { champion in createChampionModel(from: champion) }.sorted { $0.name < $1.name }
         self.filteredChampionData = self.championData
         self.delegate?.success()
     }

     private func handleFailureResponse(_ error: Error) {
         self.delegate?.error()
         print("Error fetching champions: \(error.localizedDescription)")
     }

     func request() {
         API.shared.getAllChampions { result in
             switch result {
             case .success(let response):
                 self.handleSuccessResponse(response)
             case .failure(let error):
                 self.handleFailureResponse(error)
             }
         }
     }
    

    func getFilteredChampionData() -> [ChampionModel] {
        return filteredChampionData
    }

    func filterChampions(with searchText: String) {
        if searchText.isEmpty {
            filteredChampionData = championData
        } else {
            filteredChampionData = championData.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
        delegate?.success()
    }

    func isSelected(champion: ChampionModel) -> Bool {
        return selectedChampions.contains(where: { $0.id == champion.id })
    }

    func selectChampion(champion: ChampionModel) {
        if selectedChampions.count < 2, !selectedChampions.contains(where: { $0.id == champion.id }) {
            selectedChampions.append(champion)
        }
    }

    func deselectChampion(champion: ChampionModel) {
        if let index = selectedChampions.firstIndex(where: { $0.id == champion.id }) {
            selectedChampions.remove(at: index)
        }
    }

    func getSelectedChampionNames() -> [String] {
        return selectedChampions.map { $0.name }
    }

    func getSelectedChampionImageURLs() -> [URL] {
        return selectedChampions.compactMap { $0.imageURL }
    }
}
