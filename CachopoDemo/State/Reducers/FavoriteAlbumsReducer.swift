//
//  FavoriteAlbumsReducer.swift
//  CachopoDemo
//
//  Created by Ricardo Sánchez Sotres on 2/10/16.
//  Copyright © 2016 Ricardo Sánchez Sotres. All rights reserved.
//

import Foundation

func favoriteAlbumsReducer(state: FavoriteAlbumsState?, action: Action) -> FavoriteAlbumsState {
    
    var state = state ?? FavoriteAlbumsState(albums:[])
    
    switch action {
    case let action as ToggleFavoriteAlbum:
        if let _ = state.albums.indexOf(action.album) {
            state.albums = state.albums.filter {
                $0.albumId != action.album.albumId
            }
        } else {
            state.albums = state.albums + [action.album]
        }
    case let action as AddFavoriteAlbum:
        state.albums = state.albums + [action.album]
        
    case let action as RemoveFavoriteAlbum:
        state.albums = state.albums.filter {
            $0.albumId != action.albumId
        }
        
    case let action as RemoveFavoriteArtist:
        state.albums = state.albums.filter {
            $0.artistId != action.artistId
        }
        
    default:
        break
    }
    
    return state
}