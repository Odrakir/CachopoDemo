//
//  SearchResultCell.swift
//  CachopoDemo
//
//  Created by Ricardo Sánchez Sotres on 2/10/16.
//  Copyright © 2016 Ricardo Sánchez Sotres. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SearchResultCell: UITableViewCell {

    @IBOutlet weak var thumbView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var starBtn: UIButton!
    
    var artist:Artist? {
        didSet {
            if let artist = artist {
                artistSubject.onNext(artist)
            }
        }
    }
    
    var toggleFavoriteArtist:(artist:Artist) -> () = { _ in print("Old method") }
    
    private var artistSubject = PublishSubject<Artist>()
    private var artistObservable:Observable<Artist> {
        return artistSubject.asObservable()
    }
    
    private let disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        starBtn.setImage(UIImage(named: "music"), forState: .Selected)
        
        thumbView.image = UIImage(named: "vinyl")
        selectionStyle = .None
        
        doBindings()
    }
    
    func doBindings()
    {
        artistObservable
            .map { $0.name }
            .bindTo(nameLabel.rx_text)
            .addDisposableTo(disposeBag)
        
        artistObservable
            .map { $0.thumb }
            .ignoreNil()
            .observeOn(ConcurrentDispatchQueueScheduler(globalConcurrentQueueQOS: .Background))
            .map {
                UIImage(data:NSData(contentsOfURL: $0)!)
            }
            .observeOn(MainScheduler.instance)
            .bindTo(thumbView!.rx_image)
            .addDisposableTo(disposeBag)
        
        
        
        
        starBtn.rx_tap
            .withLatestFrom(artistObservable)
            .subscribeNext {
                self.toggleFavoriteArtist(artist: $0)
            }
            .addDisposableTo(disposeBag)
        
        let favoriteArtistsObservable = rxStore.observable{ $0.favoriteArtistsState }
            .distinctUntilChanged()
        
        Observable.combineLatest(artistObservable, favoriteArtistsObservable) { ($0, $1) }
            .map {artist, favorites in
                return favorites.artists.contains(artist)
            }
            .bindTo(starBtn.rx_selected)
            .addDisposableTo(disposeBag)

    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        thumbView.image = UIImage(named: "vinyl")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        thumbView.layer.cornerRadius = thumbView.frame.size.width/2
    }
}
