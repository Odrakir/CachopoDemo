//
//  FavoriteAlbumCell.swift
//  CachopoDemo
//
//  Created by Ricardo Sánchez Sotres on 4/10/16.
//  Copyright © 2016 Ricardo Sánchez Sotres. All rights reserved.
//

import UIKit
import RxSwift

class FavoriteAlbumCell: UITableViewCell {

    @IBOutlet weak var coverView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var starBtn: UIButton!
    
    
    var album:Album? {
        didSet {
            if let album = album {
                albumSubject.onNext(album)
            }
        }
    }
    
    var toggleFavoriteAlbum:(album:Album) -> () = { _ in () }
    
    private var albumSubject = PublishSubject<Album>()
    private var albumObservable:Observable<Album> {
        return albumSubject.asObservable()
    }
    
    private let disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        starBtn.setImage(UIImage(named: "music"), forState: .Selected)
        
        coverView.image = UIImage(named: "vinyl")
        selectionStyle = .None
        
        doBindings()
    }
    
    func doBindings()
    {
        albumObservable
            .map { $0.name }
            .bindTo(titleLabel.rx_text)
            .addDisposableTo(disposeBag)
        
        albumObservable
            .map { $0.thumb }
            .ignoreNil()
            .observeOn(ConcurrentDispatchQueueScheduler(globalConcurrentQueueQOS: .Background))
            .map {
                UIImage(data:NSData(contentsOfURL: $0)!)
            }
            .observeOn(MainScheduler.instance)
            .bindTo(coverView!.rx_image)
            .addDisposableTo(disposeBag)
        
        
        
        
        starBtn.rx_tap
            .withLatestFrom(albumObservable)
            .subscribeNext {
                self.toggleFavoriteAlbum(album: $0)
            }
            .addDisposableTo(disposeBag)
        
        let favoriteAlbumsObservable = rxStore.observable{ $0.favoriteAlbumsState }
            .distinctUntilChanged()
        
        Observable.combineLatest(albumObservable, favoriteAlbumsObservable) { ($0, $1) }
            .map {album, favorites in
                return favorites.albums.contains(album)
            }
            .bindTo(starBtn.rx_selected)
            .addDisposableTo(disposeBag)
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        coverView.image = UIImage(named: "vinyl")
    }
}
