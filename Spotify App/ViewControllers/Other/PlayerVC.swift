//
//  PlayerVC.swift
//  Spotify App
//
//  Created by Жансая Шакуали on 02.01.2024.
//

import UIKit
import SDWebImage

protocol PlayerVCDelegate: AnyObject {
    func didTapPause()
    func didTapBackward()
    func didTapForward()
    func didSlideSLider(_ value: Float)
}

class PlayerVC: UIViewController {
    
    weak var dataSource: PlayerDataSource?
    weak var delegate: PlayerVCDelegate?
    
    private let controlsView = PlayerControlsView()
    
    private let imageView: UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .systemCyan
        return imageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(imageView)
        view.addSubview(controlsView)
        controlsView.delegate = self
        
        configure()
        configureButtons()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        imageView.frame = CGRect(x: 0, y: view.safeAreaInsets.top, width: view.width, height: view.width)
        controlsView.frame = CGRect(x: 10, y: imageView.bottom + 10, width: view.width - 20, height: view.height - imageView.height - view.safeAreaInsets.top - view.safeAreaInsets.bottom - 15)
    }
    
    private func configureButtons() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(didTapClose))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(didTapAction))
    }
    
    private func configure() {
        imageView.sd_setImage(with: dataSource?.imageURL)
        controlsView.configure(with: PlayerControlsViewViewModel(name: dataSource?.songName, subtitle: dataSource?.subtitle))
    }
    
    @objc func didTapClose() {
        dismiss(animated: true)
    }
    
    @objc func didTapAction() {
        //actions
    }
    
    func refreshUI() {
        configure()
    }
}

extension PlayerVC: PlayerControlsViewDelegate {
    func playerControlsView(_ playerControlsView: PlayerControlsView, didSlideSlider value: Float) {
        delegate?.didSlideSLider(value)
    }
    
    
    func playerControlsViewDidTapPauseButton(_ playerControlsView: PlayerControlsView) {
        delegate?.didTapPause()
    }
    
    func playerControlsViewDidTapNextButton(_ playerControlsView: PlayerControlsView) {
        delegate?.didTapForward()
    }
    
    func playerControlsViewDidTapBackButton(_ playerControlsView: PlayerControlsView) {
        delegate?.didTapBackward()
    }
    
    
}
