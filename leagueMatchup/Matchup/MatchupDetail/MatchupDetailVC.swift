//
//  MatchupDetailVC.swift
//  leagueMatchup
//
//  Created by João Gabriel Lavareda Ayres Barreto on 07/03/24.
//

import UIKit
import CoreData

protocol MatchupDetailVCDelegate: AnyObject {
    func didTapeSaveDetails()
}

class MatchupDetailVC: UIViewController {
    
    private var persistentContainer: NSPersistentContainer
    private var fetchedResultsController: NSFetchedResultsController<MatchupDetail>!
    private var matchup: Matchup
    
    var screen: MatchupDetailView?
    
    override func loadView() {
        screen = MatchupDetailView()
        view = screen
    }
    
    init(persistentContainer: NSPersistentContainer, matchup: Matchup) {
        self.persistentContainer = persistentContainer
        self.matchup = matchup
        super.init(nibName: nil, bundle: nil)
        
        let request = MatchupDetail.fetchRequest()
        request.predicate = NSPredicate(format: "matchupRelation = %@", matchup)
        request.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: true)]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("error")
        }
        
    }
    
    
    
    
    private func deleteMatchupMoment(_ matchupDetail: MatchupDetail) {
        
        persistentContainer.viewContext.delete(matchupDetail)
        do {
            try persistentContainer.viewContext.save()
        } catch {
            screen?.errorMessageLabel.text = "Unable to delete transaction"
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        screen?.delegate = self
        fetchedResultsController.delegate = self
        screen?.configMatchupDetailTableViewProtocols(delegate: self, dataSource: self)
        
    }
    
    var isFormValid: Bool {
        guard let description = screen?.matchupDescription.text, let timer = screen?.matchupTimer.text else {
            print("Error: matchupDescription or matchupTimer is nil")
            return false
        }
        
        return !description.isEmpty && !timer.isEmpty && timer.isNumeric && timer.isGreatorThan(0)
    }
    
    func resetForm() {
        screen?.matchupDescription.text = ""
        screen?.matchupTimer.text = ""
        screen?.errorMessageLabel.text = ""
    }
    
}

extension MatchupDetailVC: MatchupDetailVCDelegate {
    
    func didTapeSaveDetails() {
        guard let desc = screen?.matchupDescription.text, let timer = screen?.matchupTimer.text else {
            return
        }
        
        let matchupDetail = MatchupDetail(context: persistentContainer.viewContext)
        matchupDetail.matchDescription = desc
        matchupDetail.time = Double(timer) ?? 0.0
        matchupDetail.matchupRelation = matchup
        matchupDetail.createdAt = Date()
        
        do {
            try persistentContainer.viewContext.save()
            resetForm()
            screen?.tableView.reloadData()
            
        } catch {
            screen?.errorMessageLabel.text = "UNABLE TO SAVE"
        }
        
    }
}


extension MatchupDetailVC: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        screen?.tableView.reloadData()
    }
}

extension MatchupDetailVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        (fetchedResultsController.fetchedObjects ?? []).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MatchupDetailTableViewCell.reuseID, for: indexPath) as? MatchupDetailTableViewCell else {
            fatalError("Failed to dequeue a cell")
        }
        
        let matchupDetail = fetchedResultsController.object(at: indexPath)
        
        let timeInt = Int(matchupDetail.time)
        
        if "\(timeInt)".count == 4 {
            let hours = "\(timeInt)".prefix(2)
            let minutes = "\(timeInt)".suffix(2)
            
            let formattedTimeString = "\(hours):\(minutes)"
            
            cell.timeLabel.text = formattedTimeString
        } else {
            cell.timeLabel.text = "\(timeInt)"
        }
        
        cell.descriptionLabel.text = matchupDetail.matchDescription
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            let matchupDetail = fetchedResultsController.object(at: indexPath)
            deleteMatchupMoment(matchupDetail)
        }
        
    }
    
    
}
