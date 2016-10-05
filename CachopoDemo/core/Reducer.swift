//
//  Reducer.swift
//  ToDoRedux
//
//  Created by Ricardo Sánchez Sotres on 15/6/16.
//  Copyright © 2016 Ricardo Sánchez Sotres. All rights reserved.
//

public protocol AnyReducer {
    func _handleAction(action: Action, state: StateType?) -> StateType
}

public protocol Reducer: AnyReducer {
    associatedtype ReducerStateType
    func handleAction(action: Action, state: ReducerStateType?) -> ReducerStateType
}

extension Reducer {
    public func _handleAction(action: Action, state: StateType?) -> StateType {
        return withSpecificTypes(action, state: state, function: handleAction)
    }
}

func withSpecificTypes<SpecificStateType, Action>(action: Action, state genericStateType: StateType?, @noescape function: (action: Action, state: SpecificStateType?) ->SpecificStateType) -> StateType {
    
    guard let genericStateType = genericStateType else {
        return function(action: action, state: nil) as! StateType
    }
    
    guard let specificStateType = genericStateType as? SpecificStateType else {
        return genericStateType
    }
    
    return function(action: action, state: specificStateType) as! StateType
}