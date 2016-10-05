//
//  RxObserver.swift
//  Coverpocket
//
//  Created by Ricardo Sánchez Sotres on 6/7/16.
//  Copyright © 2016 CoverWallet. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

public protocol EnviromentType {}
public protocol StateType {}

public class RxStore<State:StateType, Enviroment:EnviromentType> {
    
    private var enviroment: Enviroment
    private var actions = PublishSubject<Observable<Action>>()
    private var state = Variable<State?>(nil)
    
    public func observable<S>(mapState:(State)->S) -> Observable<S>
    {
        return state.asObservable()
            .filter { $0 != nil }.map { $0! }
            .map(mapState)
            .observeOn(MainScheduler.instance)
    }
    
    public func getState() -> State
    {
        return state.value!
    }
    
    init(reducer: AnyReducer, enviroment:Enviroment) {
        self.enviroment = enviroment
        
        let _ = actions
            .flatMap { action in
                action.catchError { _ -> Observable<Action> in
                    return Observable.just(Error(origin:action))
                }
            }
            .scan(nil, accumulator: { (state, action) -> State? in
                return reducer._handleAction(action, state: state) as? State
            })
            .bindTo(state)

    }
    
    private func _dispatch(action:Observable<Action>) -> Observable<Void>
    {
        let subject = PublishSubject<Void>()
        
        self.actions.onNext(
            action
                .doOn(
                    onError: { error in
                        subject.onError(error)
                    },
                    onCompleted: {
                        subject.onNext(())
                        subject.onCompleted()
                    })            
        )
        
        return subject
            .observeOn(MainScheduler.instance)
            .asObservable()            
    }
    
    public func dispatch(action: Action) -> Observable<Void>
    {
        return _dispatch(Observable.just(action))
    }
    
    public typealias AsyncAction = Reader<(State?, Enviroment), Observable<Action>>
    public func dispatch(asyncAction:AsyncAction) -> Observable<Void>
    {
        let action = asyncAction.run((state.value, enviroment))
        return _dispatch(action)
    }
}