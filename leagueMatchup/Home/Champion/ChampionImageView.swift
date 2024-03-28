//
//  ChampionImageView.swift
//  leagueMatchup
//
//  Created by João Gabriel Lavareda Ayres Barreto on 07/02/24.
///Users/joaog./Coding/leagueMatchup/leagueMatchup/Matchup/MatchupView.swift

import UIKit

class ChampionImageView: UIImageView {
    
    let placeholderImage = UIImage(systemName: "circle.grid.cross")!
    let imageLoader = ImageLoader()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configure() {
        layer.cornerRadius = 10
        clipsToBounds = true
        image = placeholderImage
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    func loadImage(from urlString: String) {
           imageLoader.loadImage(from: urlString) { [weak self] result in
               guard let self = self else { return }
               switch result {
               case .success(let image):
                   DispatchQueue.main.async {
                       self.image = image
                   }
               case .failure(let error):
                   print("Failed to load image: \(error)")
               }
           }
       }
}
