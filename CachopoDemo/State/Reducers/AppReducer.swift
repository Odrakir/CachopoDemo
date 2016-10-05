//
//  AppReducer.swift
//  CachopoDemo
//
//  Created by Ricardo Sánchez Sotres on 26/9/16.
//  Copyright © 2016 Ricardo Sánchez Sotres. All rights reserved.
//

import Foundation

struct AppReducer: Reducer {
    
    func handleAction(action: Action, state: AppState?) -> AppState {
        
        print("======> \(action)")
        
        let state = AppState(
            searchState: searchReducer(state?.searchState, action: action),
            favoriteArtistsState: favoriteArtistsReducer(state?.favoriteArtistsState, action:action),
            favoriteAlbumsState: favoriteAlbumsReducer(state?.favoriteAlbumsState, action:action)
        )
        
        
        return state
    }
}