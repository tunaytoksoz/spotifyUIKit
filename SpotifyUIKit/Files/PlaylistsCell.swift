//
//  PlaylistsCell.swift
//  SpotifyUIKit
//
//  Created by Tunay Toksöz on 15.04.2023.
//

import UIKit


let trackCellHeight : CGFloat = 72

class PlaylistsCell: UICollectionViewCell {
    
    static let reuseIdentifier = "PlaylistsCell"
    
    var tracks :[Track]?
    
    lazy var collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 16
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(TrackCell.self, forCellWithReuseIdentifier: TrackCell.reuseIdentifier)
        cv.backgroundColor = .spotifyBlack
        
        cv.dataSource = self
        cv.delegate = self
        
        return cv
    }()
    
    override init(frame : CGRect){
        super.init(frame: .zero)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func layout(){
        addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
}

extension PlaylistsCell : UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let tracks = tracks else { return 0 }
        return tracks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrackCell.reuseIdentifier, for: indexPath) as! TrackCell
        cell.track = tracks?[indexPath.item]
        return cell
    }
}

extension PlaylistsCell :UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width, height: trackCellHeight)
    }
}

struct Track {
    let imageName : String
    let title : String
    let artist : String
}

class TrackCell: UICollectionViewCell {
    
    static let reuseIdentifier = "TrackCell"
    
    var imageView = UIImageView()
    var titleLabel = UILabel()
    var subTitleLabel = UILabel()
    
    var track : Track? {
        didSet {
            guard let track = track else { return }
            
            let image = UIImage(named: track.imageName) ?? UIImage(named: "placeholder")!
            
            imageView.image = image
            titleLabel.text = track.title
            subTitleLabel.text = track.artist
        }
    }
    
    override init(frame : CGRect){
        super.init(frame: .zero)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func layout(){
        titleLabel.font = UIFont.preferredFont(forTextStyle: .body).withTraits(traits: .traitBold)
        subTitleLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
        subTitleLabel.alpha = 0.7
    
        imageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        subTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let stackView = makeStackView(axis: .vertical)
        stackView.spacing = 6
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(subTitleLabel)
        
        addSubview(imageView)
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.heightAnchor.constraint(equalToConstant: trackCellHeight),
            imageView.widthAnchor.constraint(equalToConstant: trackCellHeight),
            
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            stackView.leadingAnchor.constraint(equalToSystemSpacingAfter: imageView.trailingAnchor, multiplier: 2),
            trailingAnchor.constraint(equalToSystemSpacingAfter: stackView.trailingAnchor, multiplier: 3)
        ])
    }
}
