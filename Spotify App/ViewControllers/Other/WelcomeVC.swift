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
        button.setTitleColor(.blue, for: .normal)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Spotify"
        view.backgroundColor = .systemYellow
        view.addSubview(signInButton)
        signInButton.addTarget(self, action: #selector(didTapSignIn), for: .touchUpInside)
        
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
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
