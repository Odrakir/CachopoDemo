//
//  Array+CachopoExtensions.swift
//  CachopoDemo
//
//  Created by Ricardo Sánchez Sotres on 26/9/16.
//  Copyright © 2016 Ricardo Sánchez Sotres. All rights reserved.
//

import Foundation
import RxSwift

extension SequenceType where Generator.Element == RxStore<AppState, Enviroment>.AsyncAction {
    
    func toAction() -> RxStore<AppState, Enviroment>.AsyncAction
    {
        let sequence = self
        return RxStore<AppState, Enviroment>.AsyncAction{ state, enviroment in
            
            let p = sequence.map {
                $0.run((state, enviroment))
            }
            
            return p.concat()
        }
    }
}