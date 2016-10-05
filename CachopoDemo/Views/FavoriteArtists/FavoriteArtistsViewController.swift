//
//  FavoriteArtistsViewController.swift
//  CachopoDemo
//
//  Created by Ricardo Sánchez Sotres on 2/10/16.
//  Copyright © 2016 Ricardo Sánchez Sotres. All rights reserved.
//

import UIKit
import RxSwift
import RxDataSources

class FavoriteArtistsViewController: CachopoViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var dataSource = RxTableViewSectionedAnimatedDataSource<AnimatableSection<Artist>>()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 80
        
        rxStore.observable { $0.favoriteArtistsState }
            .distinctUntilChanged()
            .map {
                [AnimatableSection<Artist>(header: "", items: $0.artists)]
            }
            .bindTo(tableView.rx_itemsWithDataSource(dataSource))
            .addDisposableTo(disposeBag)
        
        dataSource.configureCell = {
            _, tableView, indexPath, artist in
            let cell = tableView.dequeueReusableCellWithIdentifier("artistCell", forIndexPath: indexPath) as! ArtistTableViewCell
            
            cell.artist = artist
            
            return cell
        }
        
        dataSource.canEditRowAtIndexPath = { _ in true }

        tableView.rx_itemDeleted
            .map(dataSource.itemAtIndexPath)
            .subscribeNext(removeArtist)
            .addDisposableTo(disposeBag)
        
        tableView.rx_modelSelected(Artist)
            .subscribeNext(showDetail)
            .addDisposableTo(disposeBag)
    }

    @IBAction func addArtist(sender: AnyObject) {
        let vc = storyboard?.instantiateViewControllerWithIdentifier("search")
        self.presentViewController(vc!, animated: true, completion: nil)
    }
    
    private func removeArtist(artist:Artist) {
        rxStore.dispatch(RemoveFavoriteArtist(artistId: artist.artistId))
    }
    
    private func showDetail(artist:Artist) {
        rxStore.dispatch([getAlbums(ofArtist: artist), getSimilar(ofArtist: artist)].toAction())
            .trackActivityUI(showActivityIndicator)
            .subscribeNext {[unowned self] _ in
                let vc = self.storyboard!.instantiateViewControllerWithIdentifier("detail") as! DetailViewController
                vc.artistId = artist.artistId
                self.navigationController?.pushViewController(vc, animated: true)
            }
            .addDisposableTo(disposeBag)
    }
}

extension FavoriteArtistsViewController
{
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        guard let selected = tableView.indexPathForSelectedRow else { return }
        tableView.deselectRowAtIndexPath(selected, animated: true)
    }
}




extension Artist:AnimatableItem {
    typealias Identity = String
    
    var identity : String {
        return artistId
    }
}
