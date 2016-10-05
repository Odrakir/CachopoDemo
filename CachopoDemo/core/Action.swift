//
//  Action.swift
//  ToDoRedux
//
//  Created by Ricardo Sánchez Sotres on 15/6/16.
//  Copyright © 2016 Ricardo Sánchez Sotres. All rights reserved.
//

import Foundation
import RxSwift

public protocol Action { }

struct Init:Action { }
struct Error:Action {
    let origin:Action
}

public protocol RxAction:Action {}
extension Observable:RxAction {}
