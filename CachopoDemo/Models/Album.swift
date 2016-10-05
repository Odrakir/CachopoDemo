//
//  Album.swift
//  CachopoDemo
//
//  Created by Ricardo Sánchez Sotres on 28/9/16.
//  Copyright © 2016 Ricardo Sánchez Sotres. All rights reserved.
//

import Foundation

struct Album:Equatable
{
    var artistId:String?
    
    let albumId:String
    let type:String
    let name:String
    let images:[String]
    
    var thumb:NSURL? {
        guard let imageURL = images.last else { return nil }
        return NSURL(string:imageURL)
    }
}

func ==(lhs: Album, rhs: Album) -> Bool {
    return lhs.albumId == rhs.albumId
}

