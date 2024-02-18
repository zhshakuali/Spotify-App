//
//  PlaylistHeaderCollectionReusableView.swift
//  Spotify App
//
//  Created by Жансая Шакуали on 25.01.2024.
//

import UIKit
import SDWebImage

protocol PlaylistHeaderCollectionReusableViewDelegate: AnyObject {
    func playlistHeaderCollectionReusableViewDidTapPlayAll(_ header: PlaylistHeaderCollectionReusableView)
}

class PlaylistHeaderCollectionReusableView: UICollectionReusableView {
        
    static let identifier = "PlaylistHeaderCollectionReusableView"
    
    weak var delegate: PlaylistHeaderCollectionReusableViewDelegate?
    
    private let imageView: UIImageView = {
       let image = UIImageView()
        image.image = UIImage(systemName: "photo")
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    private let nameLabel: UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .bold)
        return label
    }()
    
    private let descriptionLabel: UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .light)
        label.numberOfLines = 0
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let ownerNameLabel: UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .light)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let playAllButton: UIButton = {
       let button = UIButton()
        button.backgroundColor = .systemGreen
        button.tintColor = .white
        let image = UIImage(systemName: "play.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30, weight: .regular))
        button.setImage(image, for: .normal)
        button.layer.cornerRadius = 30
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(didTapPlayButton), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        addSubview(imageView)
        addSubview(nameLabel)
        addSubview(descriptionLabel)
        addSubview(ownerNameLabel)
        addSubview(playAllButton)
    }

required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let imageSize: CGFloat = height/1.8
        imageView.frame = CGRect(x: (width-imageSize)/2, y: 20, width: imageSize, height: imageSize)
        
        nameLabel.frame = CGRect(x: 10, y: imageView.bottom, width: width - 20, height: 44)
        descriptionLabel.frame = CGRect(x: 10, y: nameLabel.bottom, width: width - 20, height: 44)
        ownerNameLabel.frame = CGRect(x: 10, y: descriptionLabel.bottom, width: width - 20, height: 44)
        playAllButton.frame = CGRect(x: width - 80, y: height - 80, width: 60, height: 60)
    }
    
    @objc func didTapPlayButton() {
        delegate?.playlistHeaderCollectionReusableViewDidTapPlayAll(self)
    }
    
    func configure(with viewModel: PlaylistHeaderViewModel) {
        nameLabel.text = viewModel.name
        descriptionLabel.text = viewModel.description
        ownerNameLabel.text = viewModel.owner
        imageView.sd_setImage(with: viewModel.artWorkURL, placeholderImage: UIImage(systemName: "photo"))
    }
}
