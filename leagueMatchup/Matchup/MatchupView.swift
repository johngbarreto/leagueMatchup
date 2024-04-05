//
//  MatchupView.swift
//  leagueMatchup
//
//  Created by João Gabriel Lavareda Ayres Barreto on 16/02/24.
//

import UIKit



class MatchupView: UIView {
    
    weak var delegate: MatchupViewDelegate?
    
    let imageLoader = ImageLoader()
    
    var selectedChampioNames: [String] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(red: 31/255, green: 31/255, blue: 31/255, alpha: 1)
        addViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setChampionNames(leftChampionName: String, rightChampionName: String) {
        leftChampionLabel.text = leftChampionName
        rightChampionLabel.text = rightChampionName
    }
    
    func configPickerViewProtocols(delegate: UIPickerViewDelegate, dataSource: UIPickerViewDataSource) {
        pickerView.delegate = delegate
        pickerView.dataSource = dataSource
    }
    
    func setLeftChampionImage(from url: URL) {
        imageLoader.loadImage(from: url.absoluteString) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let image):
                DispatchQueue.main.async {
                    self.leftChampionImg.image = image
                }
            case .failure(let error):
                print("Error loading left champion image: \(error)")
            }
        }
    }
    
    func setRightChampionImage(from url: URL) {
        imageLoader.loadImage(from: url.absoluteString) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let image):
                DispatchQueue.main.async {
                    self.rightChampionImg.image = image
                }
            case .failure(let error):
                print("Error loading right champion image: \(error)")
            }
        }
    }
    
    lazy var pickerView: UIPickerView = {
        let pickerView = UIPickerView()
        return pickerView
    }()
    
    
    lazy var mainLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = .white
        label.text = "Select Lane"
        return label
    }()
    
    var leftChampionImg: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "circle.hexagongrid.circle")
        imageView.tintColor = .red
        return imageView
    }()
    
    lazy var leftChampionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.font = UIFont.boldSystemFont(ofSize: 24)
        return label
    }()
    
    
    lazy var labelVS: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "VS."
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.font = UIFont.boldSystemFont(ofSize: 24)
        return label
    }()
    
    var rightChampionImg: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "circle.hexagongrid.circle")
        return imageView
    }()
    
    lazy var rightChampionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.font = UIFont.boldSystemFont(ofSize: 24)
        return label
    }()
    
    
    lazy var saveMatchupBtn: UIButton = {
        var config = UIButton.Configuration.bordered()
        let btn = UIButton(configuration: config)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
        btn.setTitle("Save", for: .normal)
        btn.layer.cornerRadius = 10
        btn.setTitleColor(UIColor.black, for: .normal )
        btn.addTarget(self, action: #selector(createMatchup), for: .touchUpInside)
        return btn
    }()
    
    @objc func createMatchup() {
        delegate?.didSaveMatchup()
        
    }
    
    lazy var errorMsgLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.red
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.numberOfLines = 0
        return label
    }()
    
    
    lazy var pickerViewContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    
    private func addViews() {
        addSubview(mainLabel)
        addSubview(leftChampionImg)
        addSubview(leftChampionLabel)
        addSubview(labelVS)
        addSubview(rightChampionImg)
        addSubview(rightChampionLabel)
        addSubview(pickerViewContainer)
        addSubview(saveMatchupBtn)
        
        pickerViewContainer.addSubview(pickerView)
        
    }
    
    
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            mainLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 15),
            mainLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            leftChampionImg.trailingAnchor.constraint(equalTo: labelVS.leadingAnchor, constant: -25),
            leftChampionImg.widthAnchor.constraint(equalToConstant: 100),
            leftChampionImg.heightAnchor.constraint(equalToConstant: 100),
            leftChampionImg.centerYAnchor.constraint(equalTo: labelVS.centerYAnchor),
            
            
            leftChampionLabel.topAnchor.constraint(equalTo: leftChampionImg.bottomAnchor, constant: 5),
            leftChampionLabel.centerXAnchor.constraint(equalTo: leftChampionImg.centerXAnchor),
            
            
            labelVS.centerXAnchor.constraint(equalTo: centerXAnchor),
            labelVS.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: 45),
            
            rightChampionImg.leadingAnchor.constraint(equalTo: labelVS.trailingAnchor, constant: 25),
            rightChampionImg.widthAnchor.constraint(equalToConstant: 100),
            rightChampionImg.heightAnchor.constraint(equalToConstant: 100),
            rightChampionImg.centerYAnchor.constraint(equalTo: labelVS.centerYAnchor),
            
            rightChampionLabel.topAnchor.constraint(equalTo: rightChampionImg.bottomAnchor, constant: 5),
            rightChampionLabel.centerXAnchor.constraint(equalTo: rightChampionImg.centerXAnchor),
            
            pickerViewContainer.topAnchor.constraint(equalTo: labelVS.bottomAnchor, constant: 100),
            pickerViewContainer.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
            pickerViewContainer.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30),
            
            pickerView.topAnchor.constraint(equalTo: pickerViewContainer.topAnchor),
            pickerView.leadingAnchor.constraint(equalTo: pickerViewContainer.leadingAnchor),
            pickerView.bottomAnchor.constraint(equalTo: pickerViewContainer.bottomAnchor),
            
            saveMatchupBtn.centerXAnchor.constraint(equalTo: centerXAnchor),
            saveMatchupBtn.topAnchor.constraint(equalTo: pickerViewContainer.bottomAnchor, constant: 20),
            
        ])
    }
    
}
