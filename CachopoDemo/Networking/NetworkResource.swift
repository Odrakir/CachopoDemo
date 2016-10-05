//
//  NetworkResource.swift
//  Coverpocket
//
//  Created by Ricardo Sánchez Sotres on 12/7/16.
//  Copyright © 2016 CoverWallet. All rights reserved.
//

import Foundation

public typealias JSONDictionary = [String: AnyObject]

struct NetworkResource<A>
{
    let url: NSURL
    let path: String
    let method : HttpMethod<NSData>
    let parameters:JSONDictionary?
    let headers : [String:String]?
    let parse: (NSData) throws -> A
}




public enum HttpMethod<Body> {
    case GET
    case POST(Body)
    case PUT(Body)
    case DELETE
}

extension HttpMethod {
    
    var name:String {
        switch self {
        case .GET: return "GET"
        case .POST: return "POST"
        case .PUT: return "PUT"
        case .DELETE: return "DELETE"
        }
    }
    
    func map<B>(f: (Body) -> B) -> HttpMethod<B> {
        switch self {
        case .GET:
            return .GET
        case .POST(let body):
            return .POST(f(body))
        case .PUT(let body):
            return .POST(f(body))
        case .DELETE:
            return .DELETE
        }
    }
}




extension NetworkResource
{
    static func spotify(path path:String, method:HttpMethod<AnyObject>, parameters:JSONDictionary?, parseJSON:AnyObject throws -> A) -> NetworkResource<A>
    {
        return NetworkResource<A>(
            url: NSURL(string:"https://api.spotify.com/v1")!,
            path: path,
            method: method.map { json in
                // TODO try! is not safe here anymore
                return try! NSJSONSerialization.dataWithJSONObject(json, options: [])
            },
            parameters: parameters,
            headers: nil,
            parse: { data in
                let json = try NSJSONSerialization.JSONObjectWithData(data, options:[])
                return try parseJSON(json)
        })
    }
}