//
//  PlayerControlsView.swift
//  Spotify App
//
//  Created by Жансая Шакуали on 06.02.2024.
//

import Foundation
import UIKit

protocol PlayerControlsViewDelegate: AnyObject {
    func playerControlsViewDidTapPauseButton(_ playerControlsView: PlayerControlsView)
    func playerControlsViewDidTapNextButton(_ playerControlsView: PlayerControlsView)
    func playerControlsViewDidTapBackButton(_ playerControlsView: PlayerControlsView)
    func playerControlsView(_ playerControlsView: PlayerControlsView, didSlideSlider value: Float)
}

struct PlayerControlsViewViewModel {
    let name: String?
    let subtitle: String?
}

final class PlayerControlsView: UIView {
    
    private var isPlaying = true
    weak var delegate: PlayerControlsViewDelegate?
    
    private let nameLabel: UILabel = {
       let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.numberOfLines = 1
        label.text = "Drake song"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let subtitleLabel: UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .black
        label.numberOfLines = 1
        label.textColor = .secondaryLabel
        label.text = "Drake song details"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let slider: UISlider = {
       let slider = UISlider()
        slider.value = 0.1
        slider.translatesAutoresizingMaskIntoConstraints = false
        return slider
    }()
    
    private let backButton: UIButton = {
       let button = UIButton()
        button.tintColor = .label
        let image = UIImage(systemName: "backward.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30, weight: .regular))
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let nextButton: UIButton = {
       let button = UIButton()
        button.tintColor = .label
        let image = UIImage(systemName: "forward.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30, weight: .regular))
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let pauseButton: UIButton = {
       let button = UIButton()
        button.tintColor = .label
        let image = UIImage(systemName: "pause", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30, weight: .regular))
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        addSubview(nameLabel)
        addSubview(subtitleLabel)
        
        addSubview(slider)
        slider.addTarget(self, action: #selector(didSlideSlider(_:)), for: .valueChanged)
        
        addSubview(backButton)
        addSubview(nextButton)
        addSubview(pauseButton)
        
        clipsToBounds = true
        
        nextButton.addTarget(self, action: #selector(didTapNext), for: .touchUpInside)
        backButton.addTarget(self, action: #selector(didTapBack), for: .touchUpInside)
        pauseButton.addTarget(self, action: #selector(didTapPlayPause), for: .touchUpInside)
        
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func didSlideSlider(_ slider: UISlider) {
        let value = slider.value
        delegate?.playerControlsView(self, didSlideSlider: value)
    }
    
    @objc func didTapNext() {
        delegate?.playerControlsViewDidTapNextButton(self)
    }
    
    @objc func didTapBack() {
        delegate?.playerControlsViewDidTapBackButton(self)
    }
    
    @objc func didTapPlayPause() {
        self.isPlaying = !isPlaying
        delegate?.playerControlsViewDidTapPauseButton(self)
        let pause = UIImage(systemName: "pause", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30, weight: .regular))
        let play = UIImage(systemName: "play.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30, weight: .regular))
        pauseButton.setImage(isPlaying ? pause : play, for: .normal)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: topAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 10),
            nameLabel.heightAnchor.constraint(equalToConstant: 50),
            
            subtitleLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
            subtitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            subtitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 10),
            subtitleLabel.heightAnchor.constraint(equalToConstant: 50),
            
            slider.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 10),
            slider.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            slider.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 10),
            
            backButton.topAnchor.constraint(equalTo: slider.bottomAnchor, constant: 10),
            backButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            
            nextButton.topAnchor.constraint(equalTo: slider.bottomAnchor, constant: 10),
            nextButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            
            pauseButton.topAnchor.constraint(equalTo: slider.bottomAnchor, constant: 10),
            pauseButton.centerXAnchor.constraint(equalTo: centerXAnchor)
            
        ])
    }
    
    func configure(with viewModel: PlayerControlsViewViewModel) {
        nameLabel.text = viewModel.name
        subtitleLabel.text = viewModel.subtitle
    }
}
