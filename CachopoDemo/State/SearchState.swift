//
//  SearchState.swift
//  CachopoDemo
//
//  Created by Ricardo Sánchez Sotres on 26/9/16.
//  Copyright © 2016 Ricardo Sánchez Sotres. All rights reserved.
//

import Foundation

struct SearchState:Equatable
{
    var searchString:String
    var artists:[Artist]
}


func ==(lhs: SearchState, rhs: SearchState) -> Bool {
    return lhs.artists == rhs.artists
}

extension SearchState:CustomStringConvertible
{
    var description: String {
        var str = "Search string: \(searchString)"
        let names = artists.map({$0.name})
        str += "\n\t\(names.count) results: "+names.joinWithSeparator("|")
        return str
    }
}