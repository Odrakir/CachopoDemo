//
//  Album+Networking.swift
//  CachopoDemo
//
//  Created by Ricardo Sánchez Sotres on 2/10/16.
//  Copyright © 2016 Ricardo Sánchez Sotres. All rights reserved.
//

import Foundation

extension Album
{
    init (artistId:String, dictionary:JSONDictionary) throws
    {
        guard
            let albumId = dictionary["id"] as? String,
            let type = dictionary["album_type"] as? String,
            let name = dictionary["name"] as? String,
            let images = dictionary["images"] as? [JSONDictionary]
            else {
                throw NetworkingError.CouldNotDecodeJSON
        }
        
        self.albumId = albumId
        self.type = type
        self.name = name
        self.images = images.flatMap { $0["url"] as? String }
                
        self.artistId = artistId
    }
}

