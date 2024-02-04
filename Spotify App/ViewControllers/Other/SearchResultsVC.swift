//
//  SearchResultsVC.swift
//  Spotify App
//
//  Created by Жансая Шакуали on 02.01.2024.
//

import UIKit

struct SearchSection {
    let title: String
    let results: [SearchResult]
}

protocol SearchResultsVCDelegate: AnyObject {
    func didTapResult(_ result: SearchResult)
}

class SearchResultsVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var sections: [SearchSection] = []
    
    weak var delegate: SearchResultsVCDelegate?
    
    private let tableview: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.backgroundColor = .systemBackground
        tableView.register(SearchResultsSubtitleTableViewCell.self, forCellReuseIdentifier: SearchResultsSubtitleTableViewCell.identifier)
        tableView.register(SearchResultsDefaultTableViewCell.self, forCellReuseIdentifier: SearchResultsDefaultTableViewCell.identifier)
        tableView.isHidden = true
        return tableView
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        view.addSubview(tableview)
        tableview.delegate = self
        tableview.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableview.frame = view.bounds
    }
    
    func update(with results: [SearchResult]) {
        
        let artists = results.filter({
            switch $0 {
            case .artist: return true
            default: return false
            }
        })
        
        let albums = results.filter({
            switch $0 {
            case .album: return true
            default: return false
            }
        })
        
        let tracks = results.filter({
            switch $0 {
            case .track: return true
            default: return false
            }
        })
        
        let playlist = results.filter({
            switch $0 {
            case .playlist: return true
            default: return false
            }
        })
        self.sections = [
            SearchSection(title: "Songs", results: tracks),
            SearchSection(title: "Artists", results: artists),
            SearchSection(title: "Playlists", results: playlist),
            SearchSection(title: "Albums", results: albums)
        ]
        
        tableview.reloadData()
        tableview.isHidden = results.isEmpty
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let result = sections[indexPath.section].results[indexPath.row]
        
        
        
        switch result {
        case .artist(let artist):
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: SearchResultsDefaultTableViewCell.identifier,
                for: indexPath
            ) as? SearchResultsDefaultTableViewCell else {
                return UITableViewCell()
            }
            let viewModel = SearchResultsDefaultTableViewCellViewModel(
                title: artist.name,
                imageURL: URL(string: artist.images?.first?.url ?? ""))
            cell.configure(with: viewModel)
            return cell
        case .album(let album):
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: SearchResultsSubtitleTableViewCell.identifier,
                for: indexPath
            ) as? SearchResultsSubtitleTableViewCell else {
                return UITableViewCell()
            }
            let viewModel = SearchResultsSubtitleTableViewCellViewModel(
                title: album.name,
                subtitle: album.artists.first?.name ?? "",
                imageURL: URL(string: album.images.first?.url ?? ""))
            cell.configure(with: viewModel)
            return cell
        case .playlist(let playlist):
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: SearchResultsSubtitleTableViewCell.identifier,
                for: indexPath
            ) as? SearchResultsSubtitleTableViewCell else {
                return UITableViewCell()
            }
            let viewModel = SearchResultsSubtitleTableViewCellViewModel(
                title: playlist.name,
                subtitle: playlist.owner.display_name,
                imageURL: URL(string: playlist.images.first?.url ?? ""))
            cell.configure(with: viewModel)
            return cell
        case .track(let track):
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: SearchResultsSubtitleTableViewCell.identifier,
                for: indexPath
            ) as? SearchResultsSubtitleTableViewCell else {
                return UITableViewCell()
            }
            let viewModel = SearchResultsSubtitleTableViewCellViewModel(
                title: track.name,
                subtitle: track.artists.first?.name ?? "-",
                imageURL: URL(string: track.album?.images.first?.url ?? ""))
            cell.configure(with: viewModel)
            return cell
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].title
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        let result = sections[indexPath.section].results[indexPath.row]
        
        delegate?.didTapResult(result)
        
    }
    
}
