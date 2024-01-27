//
//  TitleHeaderCollectionReusableView.swift
//  Spotify App
//
//  Created by Жансая Шакуали on 26.01.2024.
//

import UIKit

class TitleHeaderCollectionReusableView: UICollectionReusableView {
    
    static let identifier = "TitleHeaderCollectionReusableView"
    
    private let titleLabel: UILabel = {
       let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .label
        label.font = .systemFont(ofSize: 22, weight: .regular)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        addSubview(titleLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        titleLabel.frame = CGRect(x: 15, y: 0, width: width - 20, height: height)
    }
    
    func configure(with title: String) {
        titleLabel.text = title
    }
        
}
