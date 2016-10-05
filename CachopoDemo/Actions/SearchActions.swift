//
//  SearchActions.swift
//  CachopoDemo
//
//  Created by Ricardo Sánchez Sotres on 27/9/16.
//  Copyright © 2016 Ricardo Sánchez Sotres. All rights reserved.
//

import Foundation
import RxSwift

struct SetArtistsSearch:Action {
    let searchString:String
    let artists:[Artist]
}

struct SetArtistAlbums:Action {
    let artist:Artist
    let albums:[Album]
}

struct SetArtistRelated:Action {
    let artist:Artist
    let related:[Artist]
}


func searchArtists(searchString:String) -> RxStore<AppState, Enviroment>.AsyncAction //typeAlias Reader<(State?, Enviroment), Observable<Action>>
{
    return RxStore<AppState, Enviroment>.AsyncAction{ state, enviroment in
        
        guard !searchString.isEmpty else {
            return Observable.just(SetArtistsSearch(searchString: "", artists: []))
        }
        
        return enviroment.service.load(Artist.matching(searchString))
            .map { SetArtistsSearch(searchString: searchString, artists: $0) }        
    }
}









func getAlbums(ofArtist artist:Artist)  -> RxStore<AppState, Enviroment>.AsyncAction
{
    return RxStore<AppState, Enviroment>.AsyncAction{ state, enviroment in
        return enviroment.service.load(artist.latestAlbums)
            .map {
                return SetArtistAlbums(artist: artist, albums: $0)
        }
    }
}












func getSimilar(ofArtist artist:Artist)  -> RxStore<AppState, Enviroment>.AsyncAction
{
    return RxStore<AppState, Enviroment>.AsyncAction{ state, enviroment in
        return enviroment.service.load(artist.relatedArtists)
            .map {
                return SetArtistRelated(artist: artist, related: $0)
        }
    }
}









extension SetArtistsSearch:CustomStringConvertible
{
    var description: String {
        return "SetArtistsSearch: \(artists.count)"
    }
}

extension SetArtistAlbums:CustomStringConvertible
{
    var description:String {
        return "SetArtistAlbums: \(artist.name)"
    }
}

extension SetArtistRelated:CustomStringConvertible
{
    var description:String {
        return "SetArtistRelated: \(artist.name)"
    }
}