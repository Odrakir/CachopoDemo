//
//  FavoriteAlbumsState.swift
//  CachopoDemo
//
//  Created by Ricardo Sánchez Sotres on 2/10/16.
//  Copyright © 2016 Ricardo Sánchez Sotres. All rights reserved.
//

import Foundation

struct FavoriteAlbumsState:Equatable
{
    var albums:[Album]
}

func ==(lhs: FavoriteAlbumsState, rhs: FavoriteAlbumsState) -> Bool {
    return lhs.albums == rhs.albums
}

extension FavoriteAlbumsState:CustomStringConvertible
{
    var description: String {
        let names = albums.map({$0.name})
        return "\tFavorite albums: "+names.joinWithSeparator("|")
    }
}