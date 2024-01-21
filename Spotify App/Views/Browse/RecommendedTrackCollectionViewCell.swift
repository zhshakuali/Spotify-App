//
//  RecommendedTrackCollectionViewCell.swift
//  Spotify App
//
//  Created by Жансая Шакуали on 20.01.2024.
//

import UIKit

class RecommendedTrackCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "RecommendedTrackCollectionViewCell"
 
    private let albumCoverImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.image = UIImage(systemName: "photo")
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let trackNameLabel: UILabel = {
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
 
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .secondarySystemBackground
        contentView.addSubview(albumCoverImageView)
        contentView.addSubview(artistNameLabel)
        contentView.addSubview(trackNameLabel)
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        albumCoverImageView.sizeToFit()
        artistNameLabel.sizeToFit()
        trackNameLabel.sizeToFit()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        albumCoverImageView.image = nil
        artistNameLabel.text = nil
        trackNameLabel.text = nil
    }
    
    func configure(with viewModel: RecommendedTracksCellViewModel) {
        trackNameLabel.text = viewModel.name
        artistNameLabel.text = viewModel.artistName
        albumCoverImageView.sd_setImage(with: viewModel.artworURL)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            albumCoverImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            albumCoverImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            albumCoverImageView.heightAnchor.constraint(equalToConstant: contentView.height),
            albumCoverImageView.widthAnchor.constraint(equalToConstant: contentView.height),
            
            trackNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            trackNameLabel.leadingAnchor.constraint(equalTo: albumCoverImageView.trailingAnchor, constant: 15),
            
            artistNameLabel.topAnchor.constraint(equalTo: trackNameLabel.bottomAnchor),
            artistNameLabel.leadingAnchor.constraint(equalTo: albumCoverImageView.trailingAnchor, constant: 15)
            
        ])
    }
}
