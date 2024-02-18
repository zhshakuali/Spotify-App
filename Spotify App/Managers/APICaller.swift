//
//  APICaller.swift
//  Spotify App
//
//  Created by Жансая Шакуали on 02.01.2024.
//

import Foundation
import UIKit

final class APICaller {
    static let shared = APICaller()
    
    struct Constants {
        static let baseAPIURL = "https://api.spotify.com/v1"
    }
    
    enum APIError: Error {
        case failedToGetData
    }
    
    private init() {}
    
    //MARK: - Search
    
    public func search(with query: String ,completion: @escaping (Result<[SearchResult], Error>) -> Void) {
        createRequest(with: URL(string: Constants.baseAPIURL + "/search?limit=10&type=album,artist,playlist,track,show,episode,audiobook&q=\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"),
                      type: .GET
        ) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                do {
                    let result = try JSONDecoder().decode(SearchResultsResponse.self, from: data)
                    
                    var searchResults: [SearchResult] = []
                    searchResults.append(contentsOf: result.tracks.items.compactMap({ .track(model: $0) }))
                    searchResults.append(contentsOf: result.albums.items.compactMap({ .album(model: $0) }))
                    searchResults.append(contentsOf: result.artists.items.compactMap({ .artist(model: $0) }))
                    searchResults.append(contentsOf: result.playlists.items.compactMap({ .playlist(model: $0) }))
                    
                    completion(.success(searchResults))
                }
                catch {
                    completion(.failure(error))
                    print(error.localizedDescription)
                }
            }
            task.resume()
        }
    }
    
    
    //MARK: - Category
    
    public func getCategories(completion: @escaping (Result<[Category], Error>) -> Void) {
        createRequest(with: URL(string: Constants.baseAPIURL + "/browse/categories?limit=30"),
                      type: .GET
        ) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(AllCategoriesResponse.self, from: data)
                    completion(.success(result.categories.items))
                }
                catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    public func getCategoryPlaylists(category: Category ,completion: @escaping (Result<[Playlist], Error>) -> Void) {
        createRequest(with: URL(string: Constants.baseAPIURL + "/browse/categories/\(category.id)/playlists"),
                      type: .GET
        ) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(CategoryPlaylistsResponse.self, from: data)
                    completion(.success(result.playlists.items))
                    
                }
                catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    
    //MARK: - Albums
    
    public func getCurrentUserAlbum(completion: @escaping (Result<[Album], Error>) -> Void) {
        createRequest(with: URL(string: Constants.baseAPIURL + "/me/albums?offset=0&limit=20"), type: .GET)
        { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(LibraryAlbumResponse.self, from: data)
                    completion(.success(result.items.compactMap({$0.album})))
                }
                catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    public func getAlbumsDetails(for album: Album, completion: @escaping (Result<AlbumDetailsResponse, Error>) -> Void) {
        createRequest(with: URL(string: Constants.baseAPIURL + "/albums/" + album.id),
                      type: .GET
        ) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(AlbumDetailsResponse.self, from: data)
                    completion(.success(result))
                }
                catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    public func saveAlbums(album: Album, completion: @escaping (Bool) -> Void ) {
        createRequest(
            with: URL(string: Constants.baseAPIURL + "/me/albums?ids=\(album.id)" ),
            type: .PUT) { baseRequest in
                var request = baseRequest
                let task = URLSession.shared.dataTask(with: request) { data, response, error in
                    guard let code = (response as? HTTPURLResponse)?.statusCode,
                            error == nil else {
                        completion(false)
                        return
                    }
                    print(code)
                    completion(code == 200)
                }
                task.resume()
        }
    }
    
    //MARK: - Playlist
    
    public func getplaylistsDetails(for playlist: Playlist, completion: @escaping (Result<PlaylistDetailsResponse, Error>) -> Void) {
        createRequest(with: URL(string: Constants.baseAPIURL + "/playlists/" + playlist.id),
                      type: .GET
        ) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                do {
                    let result = try JSONDecoder().decode(PlaylistDetailsResponse.self, from: data)
                    completion(.success(result))
                }
                catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    public func getCurrentUserPlaylist(completion: @escaping (Result<[Playlist], Error>) -> Void) {
        createRequest(
            with: URL(string: Constants.baseAPIURL + "/me/playlists/?limit=50"),
            type: .GET)
        { request in
                let task = URLSession.shared.dataTask(with: request) { data, _, error in
                    guard let data = data, error == nil else {
                        completion(.failure(APIError.failedToGetData))
                        return
                    }
                    do {
                        let result = try JSONDecoder().decode(LibraryPlaylistResponse.self, from: data)
                        completion(.success(result.items))
                    } catch {
                        print(error)
                        completion(.failure(error))
                    }
                }
                task.resume()
            }
    }
    
    public func createPlaylist(with name: String, completion: @escaping (Bool) -> Void) {
        getCurrentUserProfile { [weak self] result in
            switch result {
            case .success(let profile):
                let urlString = Constants.baseAPIURL + "/users/\(profile.id)/playlists"
                print(urlString)
                self?.createRequest(
                    with: URL(string: urlString),
                    type: .POST
                ) { baseRequest in
                        var request = baseRequest
                        let json = [
                            "name": name
                        ]
                        request.httpBody = try? JSONSerialization.data(withJSONObject: json, options: .fragmentsAllowed)
                        print("starting creation")
                        
                        let task = URLSession.shared.dataTask(with: request) { data, _, error in
                            guard let data = data, error == nil else {
                                return
                            }
                            do {
                                let result = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                                if let response = result as? [String: Any], response["id"] as? String != nil {
                                    completion(true)
                                } else {
                                    completion(false)
                                }
                                print("created:")
                            }
                            catch {
                                print(error.localizedDescription)
                                completion(false)
                            }
                        }
                        task.resume()
                    }
            case .failure(let error):
                print(error)
                completion(false)
            }
        }
    }
    
    public func addTrackToPlaylist(track: AudioTrack, playlist: Playlist, completion: @escaping (Bool) -> Void ) {
        createRequest(
            with: URL(string: Constants.baseAPIURL + "/playlists/\(playlist.id)/tracks"),
            type: .POST
        ) { baseRequest in
                
                var request = baseRequest
                let json = [
                    "uris": [
                        "spotify:track:\(track.id)"
                        ]
                ]
                request.httpBody = try? JSONSerialization.data(withJSONObject: json, options: .fragmentsAllowed)
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                
                let task = URLSession.shared.dataTask(with: request) { data, _, error in
                    guard let data = data, error == nil else {
                        completion(false)
                        return
                    }
                    do {
                        let result = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                        if let response = result as? [String: Any], response["snapshot_id"] as? String != nil {
                            completion(true)
                        }
                        else {
                            completion(false)
                        }
                    }
                        catch {
                            completion(false)
                        }
                }
                task.resume()
            }
    }
    
    public func removeTrackFromPlaylist(track: AudioTrack, playlist: Playlist, completion: @escaping (Bool) -> Void ) {
        createRequest(
            with: URL(string: Constants.baseAPIURL + "/playlists/\(playlist.id)/tracks"),
            type: .DELETE) { baseRequest in
                
                var request = baseRequest
                let json: [String: Any] = [
                    "tracks": [
                        [
                        "uri": "spotify:track:\(track.id)"
                        ]
                    ]
                ]
                request.httpBody = try? JSONSerialization.data(withJSONObject: json, options: .fragmentsAllowed)
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                
                let task = URLSession.shared.dataTask(with: request) { data, _, error in
                    guard let data = data, error == nil else {
                        completion(false)
                        return
                    }
                    
                    do {
                        let result = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                        if let response = result as? [String: Any], response["snapshot_id"] as? String != nil {
                            completion(true)
                        }
                        else {
                            completion(false)
                        }
                    }
                        catch {
                            completion(false)
                        }
                }
                task.resume()
            }
    }
    
        //MARK: - Profile
    
    public func getCurrentUserProfile(completion: @escaping (Result<UserProfile, Error>) -> Void) {
        createRequest(
            with: URL(string: Constants.baseAPIURL + "/me"),
            type: .GET
        ) { baseRequest in
            let task = URLSession.shared.dataTask(with: baseRequest) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                do {
                    let result = try JSONDecoder().decode(UserProfile.self, from: data)
                    completion(.success(result))
                } catch {
                    print(error.localizedDescription)
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    public func getNewReleases(completion: @escaping (Result<NewReleasesResponse, Error>) -> Void) {
        createRequest(with: URL(string: Constants.baseAPIURL + "/browse/new-releases?limit=50"), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                do {
                    let result = try JSONDecoder().decode(NewReleasesResponse.self, from: data)
                    completion(.success(result))
                }
                catch {
                    print(error.localizedDescription)
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    public func getFeaturedPlaylists(completion: @escaping (Result<FeaturedPlaylistsPesponse, Error>) -> Void) {
        createRequest(with: URL(string: Constants.baseAPIURL + "/browse/featured-playlists?limit=20"), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                do {
                    let result = try JSONDecoder().decode(FeaturedPlaylistsPesponse.self, from: data)
                    completion(.success(result))
                }
                catch {
                    print(error.localizedDescription)
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    //MARK: - Recommendations
    
    public func getRecommendations(genres: Set<String>,  completion: @escaping (Result<RecommendationsResponse, Error>) -> Void) {
        let seeds = genres.joined(separator: ",")
        createRequest(with: URL(string: Constants.baseAPIURL + "/recommendations?limit=20&seed_genres=\(seeds)"), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                do {
                    let result = try JSONDecoder().decode(RecommendationsResponse.self, from: data)
                    completion(.success(result))
                }
                catch {
                    print(error.localizedDescription)
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    public func getRecommendedGenres(completion: @escaping (Result<RecommendedGenresResponse, Error>) -> Void) {
        createRequest(with: URL(string: Constants.baseAPIURL + "/recommendations/available-genre-seeds"), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                do {
                    let result = try JSONDecoder().decode(RecommendedGenresResponse.self, from: data)
                    completion(.success(result))
                }
                catch {
                    print(error.localizedDescription)
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    

    
    //MARK: - HTTP Method
    
    enum HTTPMethod: String{
        case GET
        case POST
        case DELETE
        case PUT
    }
    
    private func createRequest(with url: URL?,
                               type: HTTPMethod,
                               completion: @escaping (URLRequest) -> Void) {
        AuthManager.shared.withValidToken { token in
            guard let apiURL = url else { return }
            
            var request = URLRequest(url: apiURL)
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            request.httpMethod = type.rawValue
            request.timeoutInterval = 30
            completion(request)
        }
    }
}

