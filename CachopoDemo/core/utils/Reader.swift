//
//  Reader.swift
//  CachopoDemo
//
//  Created by Ricardo Sánchez Sotres on 28/9/16.
//  Copyright © 2016 Ricardo Sánchez Sotres. All rights reserved.
//

import Foundation

public class Reader<E, A> {
    
    let g: (E) -> A
    
    init(_ g:(E) -> A) {
        self.g = g
    }
    func run(e: E) -> A {
        return g(e)
    }
    func map<B>(f:(A) -> B) -> Reader<E, B> {
        return Reader<E, B>{ e in f(self.g(e)) }
    }
    func flatMap<B>(f:(A) -> Reader<E, B>) -> Reader<E, B> {
        return Reader<E, B>{ e in f(self.g(e)).g(e) }
    }
}
