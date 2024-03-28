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

class HomeVC: UIViewController {
    
    private var fetchedResultsController: NSFetchedResultsController<Matchup>!
    
    private var persistentContainer: NSPersistentContainer
    
    init(persistentContainer: NSPersistentContainer) {
        self.persistentContainer = persistentContainer
        super.init(nibName: nil, bundle: nil)
        
        let request = Matchup.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "lane", ascending: false)]
        fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var selectedChampionImageURL: [URL] = []
    var selectedChampionNames: [String] = []
    var screen: HomeView?
    var champion: [ChampionModel] = []
    var viewModel = HomeViewModel()
    
    var selectedChampions: [ChampionModel] = []
    var filteredChampions: [ChampionModel] = []
    
    
    override func loadView() {
        screen = HomeView()
        view = screen
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barTintColor = UIColor(red: 31/255, green: 31/255, blue: 31/255, alpha: 1)
        title = "Create Matchup"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.barStyle = .black
        
        screen?.delegate = self
        viewModel.delegate(delegate: self)
        viewModel.request()
        setupNavigation()
    }
    
    func setupNavigation() {
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.isNavigationBarHidden = false
    }
    
    
}

extension HomeVC: HomeViewModelDelegate, HomeViewDelegate {
    
    func didTapCreateMatchup() {
        let matchupVC = MatchupVC(persistentContainer: persistentContainer)
        matchupVC.selectedChampionNames = selectedChampionNames
        matchupVC.selectedChampionImageURLs = selectedChampionImageURL
        navigationController?.pushViewController(matchupVC, animated: true)
    }
    
    
    func success() {
        DispatchQueue.main.async {
            self.champion = self.viewModel.getChampionData()
            self.screen?.configCollectionViewProtocols(delegate: self, dataSource: self)
            self.screen?.collectionView.reloadData()
        }
    }
    
    func error() {
        print(#function)
    }
    
    
}

extension HomeVC: NSFetchedResultsControllerDelegate {
  
}


extension HomeVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.searchText.isEmpty ? viewModel.championData.count : viewModel.searchChamps.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChampionCell.reuseID, for: indexPath) as! ChampionCell
        
        if let champion = viewModel.champion(at: indexPath.item) {
            cell.setChamp(champion: champion)
            
            let isSelected = selectedChampions.contains(champion)
            
            cell.isSelected = isSelected
        }
        
        return cell
    }
    
    func updateCreateMatchupButtonState() {
        screen?.isCreateMatchupButtonEnabled = selectedChampions.count == 2
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let selectedChampion = viewModel.champion(at: indexPath.item) else {
            return
        }
        
        if let index = selectedChampions.firstIndex(where: { $0 == selectedChampion }) {
            selectedChampions.remove(at: index)
            collectionView.deselectItem(at: indexPath, animated: true)
        } else {
            if selectedChampions.count < 2 {
                selectedChampions.append(selectedChampion)
            }
        }
        
        selectedChampionNames = selectedChampions.map { $0.name }
        selectedChampionImageURL = selectedChampions.map { $0.imageURL! }
        updateCreateMatchupButtonState()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let deselectedChampion = viewModel.champion(at: indexPath.item) else {
            return
        }
        
        if let index = selectedChampions.firstIndex(where: { $0 == deselectedChampion }) {
            selectedChampions.remove(at: index)
        }
        
        selectedChampionNames = selectedChampions.map { $0.name }
        updateCreateMatchupButtonState()
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        if selectedChampions.count >= 2 {
            return false
        }
        return true
    }
    
}
