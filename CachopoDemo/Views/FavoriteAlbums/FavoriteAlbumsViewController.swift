//
//  FavoriteAlbumsViewController.swift
//  CachopoDemo
//
//  Created by Ricardo Sánchez Sotres on 4/10/16.
//  Copyright © 2016 Ricardo Sánchez Sotres. All rights reserved.
//

import UIKit
import RxSwift
import RxDataSources

class FavoriteAlbumsViewController: CachopoViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var dataSource = RxTableViewSectionedAnimatedDataSource<AnimatableSection<Album>>()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 80
        
        rxStore.observable { $0.favoriteAlbumsState }
            .distinctUntilChanged()
            .map {
                [AnimatableSection<Album>(header: "", items: $0.albums)]
            }
            .bindTo(tableView.rx_itemsWithDataSource(dataSource))
            .addDisposableTo(disposeBag)
        
        dataSource.configureCell = {
            _, tableView, indexPath, album in
            let cell = tableView.dequeueReusableCellWithIdentifier("albumCell", forIndexPath: indexPath) as! FavoriteAlbumCell
            
            cell.album = album
            cell.toggleFavoriteAlbum = self.toggleFavoriteAlbum
            
            return cell
        }
        
        dataSource.canEditRowAtIndexPath = { _ in true }
        
        tableView.rx_itemDeleted
            .map(dataSource.itemAtIndexPath)
            .subscribeNext(removeAlbum)
            .addDisposableTo(disposeBag)
        
    }
    
    private func removeAlbum(album:Album) {
        rxStore.dispatch(RemoveFavoriteAlbum(albumId: album.albumId))
    }
    
    private func toggleFavoriteAlbum(album:Album)
    {
        dispatch(ToggleFavoriteAlbum(album: album))
    }
}


extension Album:AnimatableItem {
    typealias Identity = String
    
    var identity : String {
        return albumId
    }
}
