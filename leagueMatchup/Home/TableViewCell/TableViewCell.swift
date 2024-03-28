//
//  TableViewCell.swift
//  leagueMatchup
//
//  Created by João Gabriel Lavareda Ayres Barreto on 06/03/24.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    static let reuseID = "TableCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addViews()
        setupConstraints()
        backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var labelLeft: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        label.textColor = UIColor.black
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
    
    lazy var labelVS: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.black
        label.font = UIFont.boldSystemFont(ofSize: 24)
        return label
    }()
    
    lazy var labelRight: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        label.textColor = UIColor.black
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
    
    lazy var imageViewLeft: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "Vector")
        return imageView
    }()
    
    lazy var imageViewRight: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "Vector")
        return imageView
    }()
    
    func addViews() {
        addSubview(labelLeft)
        addSubview(labelVS)
        addSubview(labelRight)
        addSubview(imageViewLeft)
        addSubview(imageViewRight)
    }
    
    
    func setupConstraints() {
        
        NSLayoutConstraint.activate([
            labelLeft.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            labelLeft.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            labelVS.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            labelVS.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            labelRight.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            labelRight.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            imageViewLeft.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            imageViewLeft.centerYAnchor.constraint(equalTo: centerYAnchor),
            imageViewLeft.widthAnchor.constraint(equalToConstant: 50),
            imageViewLeft.heightAnchor.constraint(equalToConstant: 50),
            
            imageViewRight.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            imageViewRight.centerYAnchor.constraint(equalTo: centerYAnchor),
            imageViewRight.widthAnchor.constraint(equalToConstant: 50),
            imageViewRight.heightAnchor.constraint(equalToConstant: 50) 
        ])
    }
}
