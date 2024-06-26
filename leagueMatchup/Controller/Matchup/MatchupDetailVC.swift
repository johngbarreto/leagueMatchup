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
    func textFieldDidChange(_ text: String)
}

class MatchupDetailVC: UIViewController, UITextFieldDelegate {
    
    private var fetchedResultsController: NSFetchedResultsController<MatchupDetail>!
    private var matchup: Matchup
    
    var screen: MatchupDetailView?
    
    override func loadView() {
        screen = MatchupDetailView()
        view = screen
    }
    
    init(matchup: Matchup) {
        self.matchup = matchup
        super.init(nibName: nil, bundle: nil)
        setupFetchedResultsController()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupFetchedResultsController() {
          let request = MatchupDetail.fetchRequest()
          request.predicate = NSPredicate(format: "matchupRelation = %@", matchup)
          request.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: true)]
          fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: CoreDataManager.shared.context, sectionNameKeyPath: nil, cacheName: nil)
          fetchedResultsController.delegate = self
          
          do {
              try fetchedResultsController.performFetch()
          } catch {
              print(error.localizedDescription)
          }
      }
      
    
    private func deleteMatchupMoment(_ matchupDetail: MatchupDetail) {
        CoreDataManager.shared.context.delete(matchupDetail)
        do {
            try CoreDataManager.shared.context.save()
        } catch {
            screen?.errorMessageLabel.text = "Unable to delete"
        }
    }
    
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        screen?.delegate = self
        fetchedResultsController.delegate = self
        screen?.configMatchupDetailTableViewProtocols(delegate: self, dataSource: self)
        
    }
        
    override func beginAppearanceTransition(_ isAppearing: Bool, animated: Bool) {
        super.beginAppearanceTransition(isAppearing, animated: animated)
        if !isAppearing {
            UIView.setAnimationsEnabled(false)
        }
    }

    override func endAppearanceTransition() {
        super.endAppearanceTransition()
        UIView.setAnimationsEnabled(true)
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
    func textFieldDidChange(_ newText: String) {
        // Check if the length of newText is greater than 4
        if newText.count > 4 {
            // If it is, truncate the text to 4 characters
            let truncatedText = String(newText.prefix(4))
            screen?.matchupTimer.text = truncatedText
        } else if newText.count < 4 {
            // If it's less than 4 characters, do nothing
            // You can choose to handle this case differently if needed
        }
        // Perform any other necessary logic
    }
    
    
    func didTapeSaveDetails() {
        guard let desc = screen?.matchupDescription.text, let timer = screen?.matchupTimer.text else {
            return
        }
        
        let matchupDetail = MatchupDetail(context: CoreDataManager.shared.context)
        matchupDetail.matchDescription = desc
        matchupDetail.time = Double(timer) ?? 0.0
        matchupDetail.matchupRelation = matchup
        matchupDetail.createdAt = Date()
        
        do {
            try CoreDataManager.shared.context.save()
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
          
          // Format time string with leading zeros
          let formattedTime = String(format: "%04d", timeInt)
          
          // Extract hours and minutes from formatted time
          let hours = formattedTime.prefix(2)
          let minutes = formattedTime.suffix(2)
          
          // Create formatted time string with colon separator
          let formattedTimeString = "\(hours):\(minutes)"
          
          cell.timeLabel.text = formattedTimeString
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


