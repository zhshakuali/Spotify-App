//
//  AlbumTrackCollectionViewCell.swift
//  Spotify App
//
//  Created by Жансая Шакуали on 27.01.2024.
//

import UIKit

class AlbumTrackCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "AlbumTrackCollectionViewCell"
 
    private let trackNameLabel: UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .light)
        return label
    }()
    
    private let artistNameLabel: UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 10, weight: .regular)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .secondarySystemBackground
        addSubview(trackNameLabel)
        addSubview(artistNameLabel)
       
    }

required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        trackNameLabel.frame = CGRect(x: 10, y: 0, width: width - 20, height: 44)
        artistNameLabel.frame = CGRect(x: 10, y: trackNameLabel.bottom - 10, width: width - 20, height: 30)
    }
 
    func configure(with viewModel: AlbumTrackViewModel) {
        trackNameLabel.text = viewModel.name
        artistNameLabel.text = viewModel.artist
        
    }
}
