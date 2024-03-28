//
//  MatchupDetailView.swift
//  leagueMatchup
//
//  Created by João Gabriel Lavareda Ayres Barreto on 07/03/24.
//

import UIKit

class MatchupDetailView: UIView {
    
    weak var delegate: MatchupDetailVCDelegate?
    weak var matchupDetailVC: MatchupDetailVC?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configMatchupDetailTableViewProtocols(delegate: UITableViewDelegate, dataSource: UITableViewDataSource) {
        tableView.delegate = delegate
        tableView.dataSource = dataSource
    }
    
    private func setupUI() {
        backgroundColor = UIColor(red: 31/255, green: 31/255, blue: 31/255, alpha: 1)
    }
    
    
    lazy var matchupDescription: UITextField = {
        let textfield = UITextField()
        textfield.translatesAutoresizingMaskIntoConstraints = false
        textfield.placeholder = "Describe what to do:"
        textfield.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        textfield.leftViewMode = .always
        textfield.borderStyle = .roundedRect
        return textfield
    }()
    
    lazy var matchupTimer: UITextField = {
        let textfield = UITextField()
        textfield.translatesAutoresizingMaskIntoConstraints = false
        textfield.placeholder = "Time:"
        textfield.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        textfield.leftViewMode = .always
        textfield.borderStyle = .roundedRect
        return textfield
    }()
    
    lazy var saveMatchupDetailsBtn: UIButton = {
        var config = UIButton.Configuration.bordered()
        let btn = UIButton(configuration: config)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
        btn.setTitleColor(UIColor.black, for: .normal)
        btn.setTitle("Save", for: .normal)
        btn.layer.cornerRadius = 10
        btn.addTarget(self, action: #selector(saveMatchup), for: .touchUpInside)
        return btn
    }()
    
    
    lazy var errorMessageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.red
        label.text = ""
        label.numberOfLines = 0
        return label
    }()
    
    private func isNumeric(_ str: String) -> Bool {
        return Double(str) != nil
    }
    
    @objc func saveMatchup(_ sender: UIButton) {
        guard let matchupDetailVC = delegate as? MatchupDetailVC else {
            print("Error: Unable to access MatchupDetailVC")
            return
        }
        
        if matchupDetailVC.isFormValid {
            delegate?.didTapeSaveDetails()
        } else {
            print("Error: Form is not valid")
            errorMessageLabel.text = "Make sure description and time are valid."
        }
    }
    
    lazy var tableView: UITableView = {
        tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(MatchupDetailTableViewCell.self, forCellReuseIdentifier: MatchupDetailTableViewCell.reuseID)
        tableView.backgroundColor = UIColor(red: 31/255, green: 31/255, blue: 31/255, alpha: 1)
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = UIColor.gray // Set the color of the separator bar
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        return tableView
    }()
    
    func addViews() {
        addSubview(matchupDescription)
        addSubview(matchupTimer)
        addSubview(saveMatchupDetailsBtn)
        addSubview(errorMessageLabel)
        addSubview(tableView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            matchupDescription.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
            matchupDescription.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            matchupDescription.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            matchupDescription.heightAnchor.constraint(equalToConstant: 44),
            
            matchupTimer.topAnchor.constraint(equalTo: matchupDescription.bottomAnchor, constant: 20),
            matchupTimer.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            matchupTimer.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            matchupTimer.heightAnchor.constraint(equalToConstant: 44),
            
            
            saveMatchupDetailsBtn.topAnchor.constraint(equalTo: matchupTimer.bottomAnchor, constant: 20),
            saveMatchupDetailsBtn.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            saveMatchupDetailsBtn.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            saveMatchupDetailsBtn.heightAnchor.constraint(equalToConstant: 44),
            
            errorMessageLabel.topAnchor.constraint(equalTo: saveMatchupDetailsBtn.bottomAnchor, constant: 5),
            errorMessageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            errorMessageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            
            
            tableView.topAnchor.constraint(equalTo: errorMessageLabel.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
        ])
    }
    
}
