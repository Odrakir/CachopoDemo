//
//  ArtistsReducer.swift
//  CachopoDemo
//
//  Created by Ricardo Sánchez Sotres on 26/9/16.
//  Copyright © 2016 Ricardo Sánchez Sotres. All rights reserved.
//

import Foundation

func searchReducer(state: SearchState?, action: Action) -> SearchState {
    
    var state = state ?? SearchState(searchString:"", artists:[])
    
    switch action {
    case let action as SetArtistsSearch:
        state.searchString = action.searchString
        state.artists = action.artists
    case let action as Error:
        print("Error: \(action.origin)")
    default:
        break
    }
    
    return state
}