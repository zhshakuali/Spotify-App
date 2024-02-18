//
//  LibraryPlaylistsVC.swift
//  Spotify App
//
//  Created by Жансая Шакуали on 12.02.2024.
//

import UIKit

class LibraryPlaylistsVC: UIViewController {
    
    var playlists = [Playlist]()
    
    public var selectionHandler: ((Playlist) -> Void)?
    
    private let noPlaylistsView = ActionLabelView()
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(SearchResultsSubtitleTableViewCell.self, forCellReuseIdentifier: SearchResultsSubtitleTableViewCell.identifier)
        tableView.isHidden = true
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        setUpNoPlaylistsView()
        fetchData()
        noPlaylistsView.delegate = self
        
        if selectionHandler != nil {
            navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(didTapClose))
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        noPlaylistsView.frame = CGRect(x: 0, y: 0, width: 150, height: 150)
        noPlaylistsView.center = view.center
        
        tableView.frame = view.bounds
    }
    
    @objc func didTapClose() {
        dismiss(animated: true)
    }
    
    private func setUpNoPlaylistsView() {
        view.addSubview(noPlaylistsView)
        noPlaylistsView.configure(with: ActionLabelViewViewModel(text: "You don't have any playlists", actionTitle: "Create"))
    }
    
    private func fetchData() {
        APICaller.shared.getCurrentUserPlaylist { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let playlist):
                    self?.playlists = playlist
                    self?.updateUI()
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    private func updateUI() {
        if playlists.isEmpty {
            //show NoPlaylist label
            noPlaylistsView.isHidden = false
            tableView.isHidden = true
        }
        else {
            // show table
            tableView.reloadData()
            tableView.isHidden = false
            noPlaylistsView.isHidden = true
        }
    }
    
   public func showPlaylistCreateAlert() {
        let alert = UIAlertController(title: "New Playlists", message: "Enter playlist name", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Playlist..."
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Create", style: .default, handler: { _ in
            
            guard let field = alert.textFields?.first,
                  let text = field.text,
                  !text.trimmingCharacters(in: .whitespaces).isEmpty
            else {
                return
            }

                APICaller.shared.createPlaylist(with: text) { success in
                    if success {
                      
                    }
                    else {
                        print("Failed creation")
                    }
                }
            
        }))
        present(alert, animated: true)
    }
}

extension LibraryPlaylistsVC: ActionLabelViewDelegate {
    func actionLabelViewDidTapButton(_ actionView: ActionLabelView) {
        showPlaylistCreateAlert()
    }
}

extension LibraryPlaylistsVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playlists.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultsSubtitleTableViewCell.identifier, for: indexPath) as? SearchResultsSubtitleTableViewCell else {
            return UITableViewCell()
        }
        let playlist = playlists[indexPath.row]
        cell.configure(with: SearchResultsSubtitleTableViewCellViewModel(
            title: playlist.name,
            subtitle: playlist.owner.display_name,
            imageURL: URL(string: playlist.images.first?.url ?? ""))
        )
         return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let playlist = playlists[indexPath.row]
        
        guard selectionHandler == nil else {
            selectionHandler?(playlist)
            dismiss(animated: true)
            return
        }
        let vc = PlaylistVC(playlist: playlist)
        vc.isOwner = true
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
