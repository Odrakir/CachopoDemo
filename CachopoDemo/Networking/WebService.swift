//
//  WebService.swift
//  Coverpocket
//
//  Created by Ricardo Sánchez Sotres on 12/7/16.
//  Copyright © 2016 CoverWallet. All rights reserved.
//

import Foundation
import RxSwift

let TIMEOUT_TIME:RxTimeInterval = 30.0

enum NetworkingError: ErrorType {
    case CouldNotDecodeJSON
    case NoData
    case BadStatus(status: Int)
    case Other(NSError)
}

protocol Service
{
    func load<A>(resource: NetworkResource<A>) -> Observable<A>
}

final class WebService:Service {
    
    static let instance = WebService()
    private init() {}
    
    var _session:NSURLSession?
    var session:NSURLSession {
        if let _session = _session {
            return _session
        }
        
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        _session = NSURLSession(configuration: configuration)
        return _session!
    }
    
    func load<A>(resource: NetworkResource<A>) -> Observable<A> {
        
        let request = NSMutableURLRequest(resource: resource)
        
        return Observable.create {[unowned self] observer in
            print("Network Request: \(request.URL!)")
            
            let task = self.session.dataTaskWithRequest(request) { data, response, error in
                
                if let error = error {
                    observer.onError(NetworkingError.Other(error))
                } else {
                    guard let HTTPResponse = response as? NSHTTPURLResponse else {
                        fatalError("Couldn't get HTTP response")
                    }
                    
                    guard let data = data else {
                        observer.onError(NetworkingError.NoData)
                        return
                    }
                    
                    if 200 ..< 300 ~= HTTPResponse.statusCode {
                        do {
                            let result = try resource.parse(data)
                            
                            observer.onNext(result)
                            observer.onCompleted()
                            
                        } catch let error {
                            observer.onError(error)
                        }
                    }
                    else {
                        observer.onError(NetworkingError.BadStatus(status: HTTPResponse.statusCode))
                    }
                }
            }
            
            task.resume()
            
            return AnonymousDisposable {
                task.cancel()
            }
            }
            
            .timeout(TIMEOUT_TIME, scheduler:MainScheduler.instance)
    }
}

extension NSMutableURLRequest
{
    convenience init<A>(resource: NetworkResource<A>) {
        
        var url = resource.url.URLByAppendingPathComponent(resource.path)
        
        if let parameters = resource.parameters {
            url = url.URLByAppendingQueryParameters(parameters)
        }
        
        self.init(URL: url)
        
        HTTPMethod = resource.method.name
        switch resource.method {
        case .POST(let data):
            HTTPBody = data
        case .PUT(let data):
            HTTPBody = data
        default:
            break
        }
        
        if let headers = resource.headers {
            for (key,value) in headers {
                setValue(value, forHTTPHeaderField: key)
            }
        }
    }
}

extension Dictionary where Key: StringLiteralConvertible, Value: AnyObject {
    
    func toString() -> String?
    {
        guard let dict = (self as? AnyObject) as? Dictionary<String, AnyObject> else { return nil }
        guard let json = try? NSJSONSerialization.dataWithJSONObject(dict, options: []) else { return nil }
        let str = String(data: json, encoding: NSUTF8StringEncoding)
        return str
    }
}

extension NSURL {
    
    func URLByAppendingQueryParameters(parametersDictionary : JSONDictionary) -> NSURL {
        guard let components = NSURLComponents(URL: self, resolvingAgainstBaseURL: false) else {
            return self
        }
        
        components.queryItems = parametersDictionary.flatMap { key, value in
            switch value {
            case let stringValue as String:
                return NSURLQueryItem(name: key, value: stringValue)
            case let jsonDictionary as JSONDictionary:
                return NSURLQueryItem(name: key, value: jsonDictionary.toString())
            default:
                return nil
            }
        }
        
        if let componentsURL = components.URL {
            return componentsURL
        }
        
        return self
    }
}