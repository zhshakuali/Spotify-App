//
//  PlaybackPresenter.swift
//  Spotify App
//
//  Created by Жансая Шакуали on 06.02.2024.
//

import Foundation
import UIKit
import AVFoundation

protocol PlayerDataSource: AnyObject {
    var songName: String? { get }
    var subtitle: String? { get }
    var imageURL: URL? { get }
}

final class PlaybackPresenter {
    
    static let shared = PlaybackPresenter()
    
    private var track: AudioTrack?
    private var tracks = [AudioTrack]()
    
    var index = 0
    
    var currentTrack: AudioTrack? {
        if let track = track, tracks.isEmpty {
            return track
        }
        else if let player = self.playerQueue, !tracks.isEmpty {
            return tracks[index]
        }
        return nil
    }
    
    var player: AVPlayer?
    var playerQueue: AVQueuePlayer?
    var playerVC: PlayerVC?
    
    func startPlayback(viewController: UIViewController, track: AudioTrack) {
        guard let url = URL(string: track.preview_url ?? "") else {
            return
        }
        player = AVPlayer(url: url)
        player?.volume = 0.0
        
        self.track = track
        self.tracks = []
        
        let vc = PlayerVC()
        vc.dataSource = self
        vc.delegate = self
        vc.title = track.name
        viewController.present(UINavigationController(rootViewController: vc), animated: true) { [weak self] in
            self?.player?.play()
        }
        self.playerVC = vc
    }
    
    func startPlayback(viewController: UIViewController, tracks: [AudioTrack]) {
        self.tracks = tracks
        self.track = nil
        
        let items: [AVPlayerItem] = tracks.compactMap({
            guard let url = URL(string: $0.preview_url ?? "") else {
                return nil
            }
            
            return AVPlayerItem(url: url)
        })
        
        self.playerQueue = AVQueuePlayer(items: items)
        
        self.playerQueue?.volume = 0
        self.playerQueue?.play()
        
        let vc = PlayerVC()
        vc.dataSource = self
        vc.delegate = self
        viewController.present(UINavigationController(rootViewController: vc), animated: true)
        self.playerVC = vc
    }
}

extension PlaybackPresenter: PlayerDataSource {
    
    var songName: String? {
        return currentTrack?.name
    }
    
    var subtitle: String? {
        currentTrack?.artists.first?.name
    }
    
    var imageURL: URL? {
        return URL(string: currentTrack?.album?.images.first?.url ?? "_")
    }
}

extension PlaybackPresenter: PlayerVCDelegate {
    func didTapPause() {
        if let player = player {
            if player.timeControlStatus == .playing {
                player.pause()
            }
            else if player.timeControlStatus == .paused {
                player.play()
            }
        }
        else if let player = playerQueue {
            if player.timeControlStatus == .playing {
                player.pause()
            }
            else if player.timeControlStatus == .paused {
                player.play()
            }
        }
    }
    func didTapBackward() {
        if tracks.isEmpty {
            //not playlist or album
            player?.pause()
            player?.play()
        }
        else if let firstItem = playerQueue?.items().first {
            playerQueue?.pause()
            playerQueue?.removeAllItems()
            playerQueue = AVQueuePlayer(items: [firstItem])
            playerQueue?.play()
            playerQueue?.volume = 0
        }
    }
    
    func didTapForward() {
        if tracks.isEmpty {
            //not playlist or album
            player?.pause()
        }
        else if let player = playerQueue {
            player.advanceToNextItem()
            index += 1
            print(index)
            playerVC?.refreshUI()
        }
    }
    
    func didSlideSLider(_ value: Float) {
        self.player?.volume = value
    }
}
