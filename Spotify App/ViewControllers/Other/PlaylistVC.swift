//
//  PlaylistVC.swift
//  Spotify App
//
//  Created by Жансая Шакуали on 02.01.2024.
//

import UIKit

class PlaylistVC: UIViewController {
    
    private var playlist: Playlist
    
    public var isOwner = false
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
    
    init(playlist: Playlist ){
        self.playlist = playlist
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var viewModels = [RecommendedTracksCellViewModel]()
    
    private var tracks = [AudioTrack]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = playlist.name
        view.backgroundColor = .systemBackground
        
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .systemBackground
        
        collectionView.register(
            RecommendedTrackCollectionViewCell.self,
            forCellWithReuseIdentifier: RecommendedTrackCollectionViewCell.identifier
        )
        collectionView.register(
            PlaylistHeaderCollectionReusableView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: PlaylistHeaderCollectionReusableView.identifier)
        
        APICaller.shared.getplaylistsDetails(for: playlist) { [weak self] result in
            
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    self?.tracks = model.tracks.items.compactMap({$0.track})
                    self?.viewModels = model.tracks.items.compactMap({
                        RecommendedTracksCellViewModel(
                            name: $0.track.name,
                            artworURL: URL(string: $0.track.album?.images.first?.url ?? "-"),
                            artistName: $0.track.artists.first?.name ?? "-")
                    })
                    self?.collectionView.reloadData()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(didTapShare))
        
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(didtapLongPress(_:)))
        collectionView.addGestureRecognizer(gesture)
    }
    
    @objc func didtapLongPress(_ gesture: UILongPressGestureRecognizer) {
        guard gesture.state == .began else {
            return
        }
        
        let touchPoint = gesture.location(in: collectionView)
        guard let indexPath = collectionView.indexPathForItem(at: touchPoint) else {
            return
        }
        
        let tracksToDelete = tracks[indexPath.row]
        
        let actionSheet = UIAlertController(title: tracksToDelete.name, message: "Would you like to remove this from the playlist?", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        actionSheet.addAction(UIAlertAction(title: "Remove", style: .destructive, handler: {  [weak self] _ in
            guard let self = self else {
                return
            }
            
            APICaller.shared.removeTrackFromPlaylist(track: tracksToDelete, playlist: self.playlist) { success in
                DispatchQueue.main.async {
                    if success {
                        self.tracks.remove(at: indexPath.row)
                        self.viewModels.remove(at: indexPath.row)
                        self.collectionView.reloadData()
                    }
                    else {
                        print("Failed to remove")
                    }
                }
            }
         
        }))
        present(actionSheet, animated: true)
    }
    
    @objc func didTapShare() {
        guard let url = URL(string: playlist.external_urls["spotify"] ?? "") else {
            return
        }
            
        let vc = UIActivityViewController(
            activityItems: [url],
            applicationActivities: []
        )
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
}

extension PlaylistVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: RecommendedTrackCollectionViewCell.identifier,
            for: indexPath) as? RecommendedTrackCollectionViewCell else {
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
            name: playlist.name,
            description: playlist.description,
            owner: playlist.owner.display_name,
            artWorkURL: URL(string: playlist.images.first?.url ?? "_")
        )
        
        header.configure(with: headerViewModel)
        header.delegate = self
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let index = indexPath.row
        let track = tracks[index]
        PlaybackPresenter.shared.startPlayback(viewController: self, track: track)
    }
}

extension PlaylistVC: PlaylistHeaderCollectionReusableViewDelegate {
    func playlistHeaderCollectionReusableViewDidTapPlayAll(_ header: PlaylistHeaderCollectionReusableView) {
        print("playing all ")
        PlaybackPresenter.shared.startPlayback(viewController: self, tracks: tracks)
    }
}
