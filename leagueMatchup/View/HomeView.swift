//
//  HomeView.swift
//  leagueMatchup
//
//  Created by João Gabriel Lavareda Ayres Barreto on 02/02/24.
//

import UIKit

class HomeView: UIView {
    
    weak var delegate: HomeViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(red: 31/255, green: 31/255, blue: 31/255, alpha: 1)
        addViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configCollectionViewProtocols(delegate: UICollectionViewDelegate, dataSource: UICollectionViewDataSource) {
        collectionView.delegate = delegate
        collectionView.dataSource = dataSource
    }
    
    func configSearchBarDelegate(delegate: UISearchBarDelegate) {
        searchBar.delegate = delegate
    }
    
    func reloadData() {
         collectionView.reloadData()
     }
    
    lazy var matchupDescLabael: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.text = "Select 2 champions to start creating a matchup!"
        label.numberOfLines = 2
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    lazy var searchBar: UISearchBar = {
       let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.clipsToBounds = true
        searchBar.isTranslucent = true
        searchBar.searchTextField.backgroundColor = .white
        searchBar.barTintColor = UIColor(red: 31/255, green: 31/255, blue: 31/255, alpha: 1)
        searchBar.placeholder = "Search by name:"
        return searchBar
    }()


    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 30
        let itemWidth = (UIScreen.main.bounds.width - 48 - 20) / 4
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        layout.scrollDirection = .vertical
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = UIColor(red: 31/255, green: 31/255, blue: 31/255, alpha: 1)
        collectionView.allowsMultipleSelection = true
        collectionView.register(ChampionCell.self, forCellWithReuseIdentifier: ChampionCell.reuseID)
        return collectionView
    }()

    
    var isCreateMatchupButtonEnabled: Bool = false {
          didSet {
              createMatchupBtn.isEnabled = isCreateMatchupButtonEnabled
              createMatchupBtn.alpha = isCreateMatchupButtonEnabled ? 1.0 : 0.5
          }
      }

    
    lazy var createMatchupBtn: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
        btn.setTitle("Create", for: .normal)
        btn.setTitleColor(UIColor.black, for: .normal)
        btn.isEnabled = false
        btn.layer.cornerRadius = 10
        btn.clipsToBounds = true
        btn.addTarget(self, action: #selector(showMatchupScreen), for: .touchUpInside)
        return btn
    }()
    
    @objc func showMatchupScreen() {
        delegate?.didTapCreateMatchup()
    }
    
    
    func addViews() {
        addSubview(matchupDescLabael)
        addSubview(searchBar)
        addSubview(collectionView)
        addSubview(createMatchupBtn)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            
           
            
            matchupDescLabael.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 5),
            matchupDescLabael.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            matchupDescLabael.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            
            searchBar.topAnchor.constraint(equalTo: matchupDescLabael.bottomAnchor, constant: 5),
            searchBar.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            searchBar.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),

            collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 10),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: createMatchupBtn.topAnchor, constant: -15),
            
            createMatchupBtn.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -25),
            createMatchupBtn.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
            createMatchupBtn.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30),
            createMatchupBtn.heightAnchor.constraint(equalToConstant: 50),


        ])
    }
}
