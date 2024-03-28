//
//  ListMatchupView.swift
//  leagueMatchup
//
//  Created by João Gabriel Lavareda Ayres Barreto on 18/03/24.
//

import UIKit

class ListMatchupView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(red: 31/255, green: 31/255, blue: 31/255, alpha: 1)
        addViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configTableViewProtocols(delegate: UITableViewDelegate, dataSource: UITableViewDataSource) {
        tableView.delegate = delegate
        tableView.dataSource = dataSource
    }
    
    lazy var tableView: UITableView = {
        tableView = UITableView()
        tableView.backgroundColor = UIColor(red: 31/255, green: 31/255, blue: 31/255, alpha: 1)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.reuseID)
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = UIColor.gray // Set the color of the separator bar
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16) 
        return tableView
    }()
    
    func addViews() {
        addSubview(tableView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.centerXAnchor.constraint(equalTo: centerXAnchor),
            tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 10),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
            tableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: 5)
        ])
    }
}
