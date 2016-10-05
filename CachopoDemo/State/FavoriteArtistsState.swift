//
//  FavoriteArtistsState.swift
//  CachopoDemo
//
//  Created by Ricardo Sánchez Sotres on 2/10/16.
//  Copyright © 2016 Ricardo Sánchez Sotres. All rights reserved.
//

import Foundation

struct FavoriteArtistsState:Equatable
{
    var artists:[Artist]
}

func ==(lhs: FavoriteArtistsState, rhs: FavoriteArtistsState) -> Bool {
    return lhs.artists == rhs.artists
}

extension FavoriteArtistsState:CustomStringConvertible
{
    var description: String {
        let names = artists.map({$0.name})
        return "\tFavorite artists: "+names.joinWithSeparator("|")
    }
}