//
//  FeaturedPlaylistCollectionViewCell.swift
//  Spotify App
//
//  Created by Жансая Шакуали on 20.01.2024.
//

import UIKit

class FeaturedPlaylistCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "FeaturedPlaylistCollectionViewCell"
    
    private let playlistCoverImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.image = UIImage(systemName: "photo")
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let playlistNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let creatorNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
 
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .secondarySystemBackground
        contentView.addSubview(playlistCoverImageView)
        contentView.addSubview(creatorNameLabel)
        contentView.addSubview(playlistNameLabel)
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        playlistCoverImageView.sizeToFit()
        creatorNameLabel.sizeToFit()
        playlistNameLabel.sizeToFit()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        playlistCoverImageView.image = nil
        creatorNameLabel.text = nil
        playlistNameLabel.text = nil
    }
    
    func configure(with viewModel: FeaturedPlaylistCellViewModel) {
        playlistCoverImageView.sd_setImage(with: viewModel.artworURL)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            playlistCoverImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            playlistCoverImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            playlistCoverImageView.heightAnchor.constraint(equalToConstant: contentView.height),
            playlistCoverImageView.widthAnchor.constraint(equalToConstant: contentView.width)
        ])
    }
}
