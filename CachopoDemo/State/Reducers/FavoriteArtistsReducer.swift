//
//  FavoriteArtistsReducer.swift
//  CachopoDemo
//
//  Created by Ricardo Sánchez Sotres on 2/10/16.
//  Copyright © 2016 Ricardo Sánchez Sotres. All rights reserved.
//

import Foundation

func favoriteArtistsReducer(state: FavoriteArtistsState?, action: Action) -> FavoriteArtistsState {
    
    var state = state ?? FavoriteArtistsState(artists:[])
    
    switch action {
    case let action as ToggleFavoriteArtist:
        if let _ = state.artists.indexOf(action.artist) {
            state.artists = state.artists.filter {
                $0.artistId != action.artist.artistId
            }
        } else {
            state.artists = state.artists + [action.artist]
        }
    case let action as AddFavoriteArtist:
        state.artists = state.artists + [action.artist]
    case let action as RemoveFavoriteArtist:
        state.artists = state.artists.filter {
            $0.artistId != action.artistId
        }
    case let action as SetArtistAlbums:
        state.artists = state.artists.map {
            guard $0.artistId == action.artist.artistId else { return $0 }
            return Artist(artistId: $0.artistId, name: $0.name, genres: $0.genres, images: $0.images, similar: $0.similar, albums: action.albums)
        }
    case let action as SetArtistRelated:
        state.artists = state.artists.map {
            guard $0.artistId == action.artist.artistId else { return $0 }
            return Artist(artistId: $0.artistId, name: $0.name, genres: $0.genres, images: $0.images, similar: action.related, albums: $0.albums)
        }
    default:
        break
    }
    
    return state
}