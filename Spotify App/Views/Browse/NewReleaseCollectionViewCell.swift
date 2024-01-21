//
//  NewReleaseCollectionViewCell.swift
//  Spotify App
//
//  Created by Жансая Шакуали on 20.01.2024.
//

import UIKit
import SDWebImage

class NewReleaseCollectionViewCell: UICollectionViewCell {
    
    private let albumCoverImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.image = UIImage(systemName: "photo")
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let albumNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let artistNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let numberOfTracksLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    static let identifier = "NewReleaseCollectionViewCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .secondarySystemBackground
        contentView.addSubview(albumNameLabel)
        contentView.addSubview(artistNameLabel)
        contentView.addSubview(numberOfTracksLabel)
        contentView.addSubview(albumCoverImageView)
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        albumNameLabel.sizeToFit()
        artistNameLabel.sizeToFit()
        numberOfTracksLabel.sizeToFit()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        albumNameLabel.text = nil
        artistNameLabel.text = nil
        numberOfTracksLabel.text = nil
        albumCoverImageView.image = nil
    }
    
    func configure(with viewModel: NewReleasesCellviewModel) {
        albumNameLabel.text = viewModel.name
        artistNameLabel.text = viewModel.artistName
        numberOfTracksLabel.text = "Tracks \(viewModel.numberOfTracks)"
        albumCoverImageView.sd_setImage(with: viewModel.artWorkURL)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            albumCoverImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            albumCoverImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            albumCoverImageView.heightAnchor.constraint(equalToConstant: contentView.height - 10),
            albumCoverImageView.widthAnchor.constraint(equalToConstant: contentView.height - 10),
            
            albumNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            albumNameLabel.leadingAnchor.constraint(equalTo: albumCoverImageView.trailingAnchor, constant: 10),
            
            artistNameLabel.topAnchor.constraint(equalTo: albumNameLabel.bottomAnchor, constant: 20),
            artistNameLabel.leadingAnchor.constraint(equalTo: albumNameLabel.leadingAnchor),
            
            numberOfTracksLabel.topAnchor.constraint(equalTo: artistNameLabel.bottomAnchor, constant: 20),
            numberOfTracksLabel.leadingAnchor.constraint(equalTo: albumNameLabel.leadingAnchor)
        ])
        
        
    }
}
