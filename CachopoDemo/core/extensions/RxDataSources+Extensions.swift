//
//  RxDataSources+Extensions.swift
//  CachopoDemo
//
//  Created by Ricardo Sánchez Sotres on 3/10/16.
//  Copyright © 2016 Ricardo Sánchez Sotres. All rights reserved.
//

import Foundation
import RxDataSources

protocol AnimatableItem:IdentifiableType, Equatable {}

struct AnimatableSection<M:AnimatableItem> {
    typealias Item = M
    var header:String
    var items:[M]
}

extension AnimatableSection : AnimatableSectionModelType {
    var identity: String {
        return header
    }
    
    init(original: AnimatableSection, items: [M]) {
        self = original
        self.items = items
    }
}
