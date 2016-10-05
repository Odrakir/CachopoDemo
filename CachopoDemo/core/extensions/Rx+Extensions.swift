//
//  Rx+Extensions.swift
//  CachopoDemo
//
//  Created by Ricardo Sánchez Sotres on 3/10/16.
//  Copyright © 2016 Ricardo Sánchez Sotres. All rights reserved.
//

import Foundation
import RxSwift

public protocol Optionable
{
    associatedtype WrappedType
    func unwrap() -> WrappedType
    func isEmpty() -> Bool
}

extension Optional : Optionable
{
    public typealias WrappedType = Wrapped
    
    /**
     Force unwraps the contained value and returns it. Will crash if there's no value stored.
     
     - returns: Value of the contained type
     */
    public func unwrap() -> WrappedType {
        return self!
    }
    
    /**
     Returns true if the Optional elements contains a value
     
     - returns: true if the Optional elements contains a value, false if it's nil
     */
    public func isEmpty() -> Bool {
        return self == nil
    }
}

extension ObservableType where E : Optionable {
    
    /**
     Takes a sequence of optional elements and returns a sequence of non-optional elements, filtering out any nil values.
     
     - returns: An observable sequence of non-optional elements
     */
    @warn_unused_result(message="http://git.io/rxs.uo")
    public func ignoreNil() -> Observable<E.WrappedType> {
        return self
            .filter { value in
                return !value.isEmpty()
            }
            .map { value -> E.WrappedType in
                value.unwrap()
        }
    }
}