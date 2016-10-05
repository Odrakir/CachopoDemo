//
//  FavoritesActions.swift
//  CachopoDemo
//
//  Created by Ricardo Sánchez Sotres on 2/10/16.
//  Copyright © 2016 Ricardo Sánchez Sotres. All rights reserved.
//

import Foundation

struct ToggleFavoriteArtist:Action
{
    var artist:Artist
}

struct AddFavoriteArtist:Action
{
    var artist:Artist
}

struct RemoveFavoriteArtist:Action
{
    var artistId:String
}

struct ToggleFavoriteAlbum:Action
{
    var album:Album
}

struct AddFavoriteAlbum:Action
{
    var album:Album
}

struct RemoveFavoriteAlbum:Action
{
    var albumId:String
}








extension ToggleFavoriteArtist:CustomStringConvertible
{
    var description: String {
        return "ToggleFavoriteArtist: \(artist.name)"
    }
}

extension AddFavoriteArtist:CustomStringConvertible
{
    var description:String {
        return "AddFavoriteArtist: \(artist.name)"
    }
}

extension RemoveFavoriteArtist:CustomStringConvertible
{
    var description:String {
        return "RemoveFavoriteArtist: \(artistId)"
    }
}

extension ToggleFavoriteAlbum:CustomStringConvertible
{
    var description:String {
        return "ToggleFavoriteAlbum: \(album.name)"
    }}

extension AddFavoriteAlbum:CustomStringConvertible
{
    var description:String {
        return "AddFavoriteAlbum: \(album.name)"
    }}

extension RemoveFavoriteAlbum:CustomStringConvertible
{
    var description:String {
        return "RemoveFavoriteAlbum: \(albumId)"
    }}


