//
//  Artist.swift
//  CachopoDemo
//
//  Created by Ricardo Sánchez Sotres on 27/9/16.
//  Copyright © 2016 Ricardo Sánchez Sotres. All rights reserved.
//

import Foundation

struct Artist:Equatable
{
    let artistId:String
    let name:String
    let genres:[String]
    let images:[String]
    
    var similar:[Artist]?
    var albums:[Album]?
    
    var thumb:NSURL? {
        guard let imageURL = images.last else { return nil }
        return NSURL(string:imageURL)
    }
    
    var bigPicture:NSURL? {
        guard let imageURL = images.first else { return nil }
        return NSURL(string:imageURL)
    }
}


func ==(lhs: Artist, rhs: Artist) -> Bool {
    return lhs.artistId == rhs.artistId
}