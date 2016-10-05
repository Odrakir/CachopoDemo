//
//  Artist+Networking.swift
//  CachopoDemo
//
//  Created by Ricardo Sánchez Sotres on 2/10/16.
//  Copyright © 2016 Ricardo Sánchez Sotres. All rights reserved.
//

import Foundation

extension Artist
{
    init (dictionary:JSONDictionary) throws
    {
        guard
            let artistId = dictionary["id"] as? String,
            let name = dictionary["name"] as? String,
            let genres = dictionary["genres"] as? [String],
            let images = dictionary["images"] as? [JSONDictionary]
            else {
                throw NetworkingError.CouldNotDecodeJSON
        }
        
        self.artistId = artistId
        self.name = name
        self.genres = genres
        self.images = images.flatMap { $0["url"] as? String }
     
        self.albums = nil
        self.similar = nil
    }
}

extension Artist
{
    static func matching(searchString:String, limit:Int = 20) -> NetworkResource<[Artist]>
    {
        return NetworkResource<[Artist]>.spotify(
            path: "search",
            method: .GET,
            parameters: ["q":"artist:\(searchString)", "type":"artist", "limit":"\(limit)"],
            parseJSON: { json in
                guard let dictionary = json as? JSONDictionary,
                    let artists = dictionary["artists"] as? JSONDictionary,
                    let items = artists["items"] as? [JSONDictionary]
                    else { throw NetworkingError.CouldNotDecodeJSON }
                
                let result = try items.map(Artist.init)
                return result
            }
        )
    }
    
    var latestAlbums:NetworkResource<[Album]> {
        return NetworkResource<[Album]>.spotify(
            path: "artists/\(artistId)/albums",
            method: .GET,
            parameters: ["market":"ES", "album_type":"album"],
            parseJSON: { json in
                guard let dictionary = json as? JSONDictionary,
                    let items = dictionary["items"] as? [JSONDictionary]
                    else { throw NetworkingError.CouldNotDecodeJSON }
                
                let result = try items.map { try Album(artistId: self.artistId, dictionary:$0) }
                return result
            }
        )
    }
    
    var relatedArtists:NetworkResource<[Artist]> {
        return NetworkResource<[Artist]>.spotify(
            path: "artists/\(artistId)/related-artists",
            method: .GET,
            parameters: nil,
            parseJSON: { json in
                guard let dictionary = json as? JSONDictionary,
                    let artists = dictionary["artists"] as? [JSONDictionary]
                    else { throw NetworkingError.CouldNotDecodeJSON }
                
                let result = try artists.map(Artist.init)
                return result
            }
        )
    }
}