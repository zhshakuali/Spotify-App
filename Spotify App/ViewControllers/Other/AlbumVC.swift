//
//  AlbumVC.swift
//  Spotify App
//
//  Created by Жансая Шакуали on 22.01.2024.
//

import UIKit

class AlbumVC: UIViewController {
    
    private var album: Album
    
    private var tracks = [AudioTrack]()
    
    private let collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewCompositionalLayout (
            sectionProvider: { _, _  -> NSCollectionLayoutSection? in
                let item = NSCollectionLayoutItem(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1),
                        heightDimension: .fractionalHeight(1)))
                
                item.contentInsets = NSDirectionalEdgeInsets(top: 1, leading: 2, bottom: 1, trailing: 2)
                
                // vertical group in horizantal group
                let group = NSCollectionLayoutGroup.vertical(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1.0),
                        heightDimension: .absolute(60)),
                    subitem: item,
                    count: 1)
                
                //section
                let section = NSCollectionLayoutSection(group: group)
                section.boundarySupplementaryItems = [
                    NSCollectionLayoutBoundarySupplementaryItem(
                        layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                           heightDimension: .fractionalHeight(0.5)),
                        elementKind: UICollectionView.elementKindSectionHeader,
                        alignment: .top)
                ]
                return section
            }))
   
    init(album: Album ){
        self.album = album
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = album.name
        view.backgroundColor = .systemBackground
        
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .systemBackground
        
        collectionView.register(
            AlbumTrackCollectionViewCell.self,
            forCellWithReuseIdentifier: AlbumTrackCollectionViewCell.identifier
        )
        collectionView.register(
            PlaylistHeaderCollectionReusableView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: PlaylistHeaderCollectionReusableView.identifier)
        fetchData()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(didTapAction))
    }
    
    private var viewModels = [AlbumTrackViewModel]()

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
    
    @objc func didTapAction() {
        let actionSheet = UIAlertController(title: album.name, message: "Action", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        actionSheet.addAction(UIAlertAction(title: "Save album", style: .default, handler: { [weak self] _ in
            guard let self = self else {
                return
            }
            APICaller.shared.saveAlbums(album: self.album) { success in
                if success {
                    NotificationCenter.default.post(name: .savedNotification, object: nil)
                }
            }
            
        }))
        present(actionSheet, animated: true)
    }
    
    private func fetchData() {
        APICaller.shared.getAlbumsDetails(for: album) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    self?.tracks = model.tracks.items
                    self?.viewModels = model.tracks.items.compactMap({
                        AlbumTrackViewModel(
                            name: $0.name,
                            artist: $0.artists.first?.name ?? "_")
                    })
                    
                    self?.collectionView.reloadData()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
}

extension AlbumVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: AlbumTrackCollectionViewCell.identifier,
            for: indexPath) as? AlbumTrackCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: viewModels[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionReusableView()
        }
        
        guard let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: PlaylistHeaderCollectionReusableView.identifier,
            for: indexPath) as? PlaylistHeaderCollectionReusableView else {
            return UICollectionReusableView()
        }
        
        let headerViewModel = PlaylistHeaderViewModel(
            name: album.name,
            description: "Release Date: \(String.formattedDate(string: album.release_date))",
            owner: album.artists.first?.name,
            artWorkURL: URL(string: album.images.first?.url ?? "_")
        )
        
        header.configure(with: headerViewModel)
        header.delegate = self
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        var track = tracks[indexPath.row]
        track.album = self.album
        PlaybackPresenter.shared.startPlayback(viewController: self, track: track)
    }
}

extension AlbumVC: PlaylistHeaderCollectionReusableViewDelegate {
    func playlistHeaderCollectionReusableViewDidTapPlayAll(_ header: PlaylistHeaderCollectionReusableView) {
        let tracksWithAlbum: [AudioTrack] = tracks.compactMap({
            var track = $0
            track.album = self.album
            return track
           
        })
        PlaybackPresenter.shared.startPlayback(viewController: self, tracks: tracksWithAlbum)
    }
}

