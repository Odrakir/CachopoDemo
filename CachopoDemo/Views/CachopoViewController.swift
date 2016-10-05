//
//  CachopoViewController.swift
//  CachopoDemo
//
//  Created by Ricardo Sánchez Sotres on 3/10/16.
//  Copyright © 2016 Ricardo Sánchez Sotres. All rights reserved.
//

import UIKit
import RxSwift

class CachopoViewController: UIViewController {

    internal var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    internal func showActivityIndicator(active:Bool)
    {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = active
    }
    
    internal func handleError(error:ErrorType) -> Observable<Void>
    {
        let alert = UIAlertController(title: "Error", message: "\(error)", preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
        
        return Observable.never()
    }
    
    internal func dispatch(action:Action) {
        rxStore.dispatch(action)
    }
    
    internal func dispatch(action:RxStore<AppState, Enviroment>.AsyncAction) {
        rxStore.dispatch(action)
            .trackActivityUI(showActivityIndicator)
            .catchError(handleError)
            .subscribe()
            .addDisposableTo(disposeBag)
    }
}
