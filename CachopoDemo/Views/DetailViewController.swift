//
//  DetailViewController.swift
//  CachopoDemo
//
//  Created by Ricardo Sánchez Sotres on 29/9/16.
//  Copyright © 2016 Ricardo Sánchez Sotres. All rights reserved.
//

import UIKit
import RxSwift
import RxDataSources

class DetailViewController: CachopoViewController {

    @IBOutlet weak var headerView: UIStackView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var relatedArtists: UILabel!
    @IBOutlet weak var artistImage: UIImageView!
    
    var artistId:String?
    
    let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, Album>>()
    
    override func viewDidLoad() {
        super.viewDidLoad()        
        
        let artistObservable = rxStore.observable { $0.favoriteArtistsState }
            .distinctUntilChanged()
            .map{ $0.artists }
            .map {[unowned self] artists in
                artists.filter { $0.artistId == self.artistId }.first
            }
            .filter { $0 != nil }.map { $0! }
            
        artistObservable
            .subscribeNext(configure)
            .addDisposableTo(disposeBag)
        
        
        artistObservable
            .map { $0.similar }
            .ignoreNil()
            .map {
                $0.map { $0.name }.joinWithSeparator(", ")
            }
            .bindTo(relatedArtists.rx_text)
            .addDisposableTo(disposeBag)        
        
        artistObservable
            .map { $0.albums }
            .ignoreNil()
            .map {
                [SectionModel<String, Album>(model: "", items: $0)]
            }
            .bindTo(tableView.rx_itemsWithDataSource(dataSource))
            .addDisposableTo(disposeBag)
        
        dataSource.configureCell = {//[unowned self]
            _, tableView, indexPath, album in
            let cell = tableView.dequeueReusableCellWithIdentifier("albumCell", forIndexPath: indexPath) as! AlbumCell
            
            cell.album = album
            cell.toggleFavoriteAlbum = self.toggleFavoriteAlbum
            
            return cell
        }
    }
    
    func configure(artist:Artist)
    {
        textLabel.text = artist.name
        artistImage.image = UIImage(data: NSData(contentsOfURL: artist.bigPicture!)!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    private func toggleFavoriteAlbum(album:Album)
    {
        dispatch(ToggleFavoriteAlbum(album: album))
    }
    

}
