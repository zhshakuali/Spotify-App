//
//  WelcomeVC.swift
//  Spotify App
//
//  Created by Жансая Шакуали on 02.01.2024.
//

import UIKit

class WelcomeVC: UIViewController {
    
    
    private let signInButton: UIButton = {
       let button = UIButton()
        button.backgroundColor = .systemBackground
        button.setTitle("Sign In with Spotify", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let imageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "background")
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    private let overlayView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = 0.7
        return view
    }()
    
    private let label: UILabel = {
       let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .white
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 32, weight: .semibold)
        label.text = "Listen to Millions\nof Songs on\nthe go"
        return label
    }()
    
    private let logoImage: UIImageView = {
       let image = UIImageView()
        image.image = UIImage(named: "logo")
        image.contentMode = .scaleAspectFit
        return image
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Spotify"
        view.backgroundColor = .systemYellow
        view.addSubview(imageView)
        view.addSubview(overlayView)
        view.addSubview(signInButton)
        signInButton.addTarget(self, action: #selector(didTapSignIn), for: .touchUpInside)
        view.addSubview(label)
        view.addSubview(logoImage)
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        imageView.frame = view.bounds
        overlayView.frame = view.bounds
        logoImage.frame = CGRect(x: (view.width - 120)/2, y: (view.height - 350)/2, width: 120, height: 120)
        label.frame = CGRect(x: 30, y: logoImage.bottom+30, width: view.width-60, height: 150)
        signInButton.frame = CGRect(
            x: 20,
            y: view.height - 50 - view.safeAreaInsets.bottom,
            width: view.width - 40,
            height: 50)
    }
    
    
    @objc func didTapSignIn() {
        let vc = AuthVC()
        vc.completionHandler = { [weak self] success in
            DispatchQueue.main.async {
                self?.handleSignIn(success: success)
            }
        }
        
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    private func handleSignIn(success: Bool) {
        
        guard success else {
            let ac = UIAlertController(title: "oops...", message: "Something get wrong", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "dismiss", style: .cancel))
            present(ac, animated: true)
            return
        }
        
        let mainTabBar = MainTabBarVC()
           mainTabBar.modalPresentationStyle = .fullScreen
           present(mainTabBar, animated: true)
        
    }


}
