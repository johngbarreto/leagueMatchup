//
//  MatchupVC.swift
//  leagueMatchup
//
//  Created by João Gabriel Lavareda Ayres Barreto on 23/02/24.
//

import UIKit
import CoreData

protocol MatchupViewDelegate: AnyObject {
    func didSaveMatchup()
}

class MatchupVC: UIViewController, MatchupViewDelegate {
    
    let pickerData = ["Top", "Mid", "Jungle", "Adc", "Support"]
    
    var selectedChampionNames: [String] = []
    var selectedChampionImageURLs: [URL] = []
    var selectedLane: String = ""
    
    private var persistentContainer: NSPersistentContainer
    
    var screen: MatchupView?
    
    init(persistentContainer: NSPersistentContainer) {
        self.persistentContainer = persistentContainer
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        screen = MatchupView()
        screen?.delegate = self
        view = screen
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        screen?.configPickerViewProtocols(delegate: self, dataSource: self)
        loadChampions()
        setupNavigationBar()
    }
    
    func setupNavigationBar() {
        navigationItem.title = "Creating"
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonTapped))
        navigationItem.leftBarButtonItem?.tintColor = UIColor.red
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    @objc func cancelButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    
    func loadChampions() {
        for (index, imageURL) in selectedChampionImageURLs.enumerated() {
            if index == 0 {
                screen?.setLeftChampionImage(from: imageURL)
                screen?.setChampionNames(leftChampionName: selectedChampionNames[index], rightChampionName: "")
            } else {
                screen?.setRightChampionImage(from: imageURL)
                screen?.setChampionNames(leftChampionName: screen?.leftChampionLabel.text ?? "", rightChampionName: selectedChampionNames[index])
            }
        }
    }
    
    
    
    func didSaveMatchup() {
        do {
            let matchup = Matchup(context: persistentContainer.viewContext)
            matchup.championName1 = selectedChampionNames.first
            matchup.championName2 = selectedChampionNames.last
            matchup.lane = selectedLane
            try persistentContainer.viewContext.save()
            
            navigationController?.dismiss(animated: true) {
                let matchupDetailVC = MatchupDetailVC(persistentContainer: self.persistentContainer, matchup: matchup)
                
                self.navigationController?.pushViewController(matchupDetailVC, animated: true)
            }
        } catch {
            displayAlert(message: "Failed to save matchup.")
        }
        
    }
    
    func displayAlert(message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
}


extension MatchupVC: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        _ = pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        selectedLane = pickerData[row]
        return pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let title = pickerData[row] // Get the text for the row
            let attributedString = NSAttributedString(string: title, attributes: [NSAttributedString.Key.foregroundColor: UIColor.white]) // Customize the text color
            return attributedString
        }
}
