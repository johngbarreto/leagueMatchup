//
//  ChampionCell.swift
//  leagueMatchup
//
//  Created by João Gabriel Lavareda Ayres Barreto on 05/02/24.
//

import UIKit

class ChampionCell: UICollectionViewCell {
    static let reuseID = "ChampionCell"
    
    
    weak var collectionView: UICollectionView?
    
    let championLabel = ChampionTitleLabel(textAlignment: .center, fontSize: 16)
    let championImg = ChampionImageView(frame: .zero)
    
    
    override var isSelected: Bool {
        didSet {
            updateAppearance()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func updateAppearance() {
        layer.borderWidth = isSelected ? 1.0 : 0.0
        layer.cornerRadius = 10
        layer.borderColor = isSelected ? UIColor.systemRed.cgColor : UIColor.clear.cgColor
    }
    
    func sanitizeChampionName(_ name: String) -> String {
        var sanitizedName = name.replacingOccurrences(of: " ", with: "")
        sanitizedName = sanitizedName.replacingOccurrences(of: "'", with: "")
        sanitizedName = sanitizedName.replacingOccurrences(of: ".", with: "")
        return sanitizedName
    }
    

    func setChamp(champion: ChampionModel) {
        championLabel.text = champion.name
        
        if let imageURL = champion.imageURL {
            championImg.loadImage(from: imageURL.absoluteString)
        } else {

        }
    }

    func getChampionImage() -> UIImage? {
        return championImg.image
    }
    
    private func configure() {
        addSubview(championImg)
        addSubview(championLabel)
        
        let padding: CGFloat = 8
        
        NSLayoutConstraint.activate([
            championImg.topAnchor.constraint(equalTo: topAnchor, constant: padding),
            championImg.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            championImg.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            championImg.heightAnchor.constraint(equalTo: championImg.widthAnchor),
            
            championLabel.topAnchor.constraint(equalTo: championImg.bottomAnchor, constant: 12),
            championLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            championLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            championLabel.heightAnchor.constraint(equalToConstant: 20),
        ])
        
        updateAppearance()
    }
    
    
}
