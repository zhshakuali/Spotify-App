//
//  GenreCollectionViewCell.swift
//  Spotify App
//
//  Created by Жансая Шакуали on 30.01.2024.
//

import UIKit
import SDWebImage

class CategoryCollectionViewCell: UICollectionViewCell {

    static let identifier = "GenreCollectionViewCell"
    
    private let imageView: UIImageView = {
       let image = UIImageView()
        image.image = UIImage(systemName: "music.quarternote.3", withConfiguration: UIImage.SymbolConfiguration(
            pointSize: 50,
            weight: .regular
        ))
        image.tintColor = .white
        image.contentMode = .scaleAspectFit
        image.layer.cornerRadius = 8
        return image
    }()
    
    private let genreNamelabel: UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .regular)
        label.textColor = .white
        return label
    }()
    
    private let colors: [UIColor] = [
        .systemGreen,
        .systemRed,
        .systemBlue,
        .systemGray,
        .systemTeal,
        .systemYellow,
        .systemCyan,
        .systemOrange,
        .systemMint,
        .systemPink,
        .systemGreen,
        .systemRed,
        .systemBlue,
        .systemGray,
        .systemTeal,
        .systemYellow,
        .systemCyan,
        .systemOrange,
        .systemMint,
        .systemPink,
        .systemBlue,
        .systemGray,
        .systemTeal,
        .systemYellow,
        .systemCyan,
    ]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.layer.masksToBounds = true
        contentView.layer.cornerRadius = 8
        contentView.addSubview(imageView)
        contentView.addSubview(genreNamelabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        genreNamelabel.text = nil
        imageView.image = UIImage(systemName: "music.quarternote.3", withConfiguration: UIImage.SymbolConfiguration(
            pointSize: 50,
            weight: .regular
        ))
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = CGRect(x: contentView.width/2, y: 10, width: contentView.width/2, height: contentView.height/2)
        genreNamelabel.frame = CGRect(x: 10, y: contentView.height/2, width: contentView.width/2, height: contentView.height/2)
    }
    
    func configure(with viewModel: CategoryCollectionViewCellViewModel, _ index: Int) {
        genreNamelabel.text = viewModel.name
        imageView.sd_setImage(with: viewModel.artWorkURL)
        
        guard index < colors.count else {
            return
        }
        backgroundColor = colors[index]
    }
}
