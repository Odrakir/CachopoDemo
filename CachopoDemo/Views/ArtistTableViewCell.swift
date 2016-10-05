//
//  ArtistTableViewCell.swift
//  CachopoDemo
//
//  Created by Ricardo Sánchez Sotres on 27/9/16.
//  Copyright © 2016 Ricardo Sánchez Sotres. All rights reserved.
//

import UIKit
import RxSwift

class ArtistTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var thumbView: UIImageView!
    
    var artist:Artist? = nil {
        didSet {
            configure()
        }
    }
    
    var disposeBag = DisposeBag()

    override func awakeFromNib() {
        super.awakeFromNib()
        thumbView.image = UIImage(named: "vinyl")
        accessoryType = .DisclosureIndicator
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        thumbView.image = UIImage(named: "vinyl")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        thumbView.layer.cornerRadius = thumbView.frame.size.width/2
    }

    func configure()
    {
        guard let artist = artist else { return }
        
        nameLabel?.text = artist.name
        
        Observable.just(artist.thumb)
            .filter { $0 != nil }.map { $0! }
            .observeOn(ConcurrentDispatchQueueScheduler(globalConcurrentQueueQOS: .Background))
            .map {
                UIImage(data:NSData(contentsOfURL: $0)!)
            }
            .observeOn(MainScheduler.instance)
            .subscribeNext {
                self.thumbView.image = $0
                self.layoutSubviews()
            }
            .addDisposableTo(disposeBag)
    }
}


