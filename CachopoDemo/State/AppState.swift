//
//  AppState.swift
//  CachopoDemo
//
//  Created by Ricardo Sánchez Sotres on 26/9/16.
//  Copyright © 2016 Ricardo Sánchez Sotres. All rights reserved.
//

import Foundation

public struct AppState:StateType
{
    var searchState:SearchState
    var favoriteArtistsState:FavoriteArtistsState
    var favoriteAlbumsState:FavoriteAlbumsState
}

extension AppState:CustomStringConvertible
{
    public var description: String {
        return "====================APP STATE=================" +
        "\n\t\(searchState.description)" +
        "\n\t\(favoriteArtistsState.description)" +
        "\n\t\(favoriteAlbumsState.description)"
    }
}