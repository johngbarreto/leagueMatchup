//
//  HomeVC.swift
//  leagueMatchup
//
//  Created by João Gabriel Lavareda Ayres Barreto on 02/02/24.
//

import UIKit
import CoreData

protocol HomeViewDelegate: AnyObject {
    func didTapCreateMatchup()
}

class HomeVC: UIViewController, NSFetchedResultsControllerDelegate {
    
    private var fetchedResultsController: NSFetchedResultsController<Matchup>!
    
    var screen: HomeView?
    var viewModel = HomeViewModel()
    
    override func loadView() {
        screen = HomeView()
        view = screen
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupFetchedResultsController()
        screen?.delegate = self
        screen?.searchBar.delegate = self
        viewModel.delegate = self
        viewModel.request()
        setupNavigation()
    }
    
    func setupNavigation() {
        navigationController?.navigationBar.barTintColor = UIColor(red: 31/255, green: 31/255, blue: 31/255, alpha: 1)
        title = "Create Matchup"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.isNavigationBarHidden = false
    }
    
    private func setupFetchedResultsController() {
        let request = Matchup.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "lane", ascending: false)]
        fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: CoreDataManager.shared.context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print(error.localizedDescription)
        }
    }
}

extension HomeVC: HomeViewModelDelegate, HomeViewDelegate {
    func didTapCreateMatchup() {
        let matchupVC = MatchupVC()
        matchupVC.selectedChampionNames = viewModel.getSelectedChampionNames()
        matchupVC.selectedChampionImageURLs = viewModel.getSelectedChampionImageURLs()
        navigationController?.pushViewController(matchupVC, animated: true)
    }

    func success() {
        DispatchQueue.main.async {
            self.screen?.configCollectionViewProtocols(delegate: self, dataSource: self)
            self.screen?.configSearchBarDelegate(delegate: self)
            self.screen?.collectionView.reloadData()
        }
    }

    func error() {
        print(#function)
    }
}

extension HomeVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.getFilteredChampionData().count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChampionCell.reuseID, for: indexPath) as! ChampionCell
        let champion = viewModel.getFilteredChampionData()[indexPath.item]
        cell.setChamp(champion: champion)
        updateCellSelectionState(cell: cell, champion: champion)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let champion = viewModel.getFilteredChampionData()[indexPath.item]
        
        viewModel.isSelected(champion: champion) ? viewModel.deselectChampion(champion: champion) : viewModel.selectChampion(champion: champion)
        
        collectionView.reloadItems(at: [indexPath])
        updateCreateMatchupButtonState()
    }
    

    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        let champion = viewModel.getFilteredChampionData()[indexPath.item]
        if viewModel.isSelected(champion: champion) {
            return true
        }
        return viewModel.getSelectedChampionNames().count < 2
    }

    func updateCreateMatchupButtonState() {
        screen?.isCreateMatchupButtonEnabled = viewModel.getSelectedChampionNames().count == 2
    }
    
    private func updateCellSelectionState(cell: UICollectionViewCell, champion: ChampionModel) {
        let isSelected = viewModel.isSelected(champion: champion)
        cell.layer.borderColor = isSelected ? UIColor.red.cgColor : UIColor.clear.cgColor
        cell.layer.borderWidth = isSelected ? 2 : 0
    }
}

extension HomeVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.filterChampions(with: searchText)
        screen?.collectionView.reloadData()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
