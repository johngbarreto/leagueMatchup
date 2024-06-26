//
//  ListMatchupVC.swift
//  leagueMatchup
//
//  Created by João Gabriel Lavareda Ayres Barreto on 18/03/24.
//

import UIKit
import CoreData


class ListMatchupVC: UIViewController {
    
    
    var screen: ListMatchupView?
    
    override func loadView() {
        screen = ListMatchupView()
        view = screen
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
        DispatchQueue.main.async {
            self.screen?.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupFetchedResultsController()
        self.screen?.configTableViewProtocols(delegate: self, dataSource: self)
        
        navigationController?.navigationBar.barTintColor = UIColor(red: 31/255, green: 31/255, blue: 31/255, alpha: 1)
        title = "Matchups"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.tintColor = UIColor.red;
    }
    
    
    private var fetchedResultsController: NSFetchedResultsController<Matchup>!
    

    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupFetchedResultsController() {
         let request = Matchup.fetchRequest()
         request.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]
         fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: CoreDataManager.shared.context, sectionNameKeyPath: nil, cacheName: nil)
         fetchedResultsController.delegate = self
         
         do {
             try fetchedResultsController.performFetch()
         } catch {
             print(error.localizedDescription)
         }
     }
     
    
       private func deleteMatchup(_ matchupDetail: Matchup) {
           CoreDataManager.shared.context.delete(matchupDetail)
           do {
               try CoreDataManager.shared.context.save()
           } catch {
               print("Error deleting matchup: \(error.localizedDescription)")
           }
       }
    
}

extension ListMatchupVC: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        DispatchQueue.main.async {
            self.screen?.tableView.reloadData()
        }
    }
}

extension ListMatchupVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = fetchedResultsController.sections?[section] else { return 0 }
        return section.numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let matchup = fetchedResultsController?.object(at: indexPath) else {
            return
        }
        
        let matchupDetailVC = MatchupDetailVC(matchup: matchup)
        
        
        navigationController?.pushViewController(matchupDetailVC, animated: false)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MatchupTableViewCell.reuseID, for: indexPath) as? MatchupTableViewCell
        
        let matchup = fetchedResultsController.object(at: indexPath)
        
        cell?.labelLeft.text = matchup.championName1
        cell?.labelVS.text = "VS."
        cell?.labelRight.text = matchup.championName2
        
        
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            let matchup = fetchedResultsController.object(at: indexPath)
            deleteMatchup(matchup)
        }
        
    }
    
}

