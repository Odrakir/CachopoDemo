//
//  SearchViewController.swift
//  CachopoDemo
//
//  Created by Ricardo Sánchez Sotres on 2/10/16.
//  Copyright © 2016 Ricardo Sánchez Sotres. All rights reserved.
//

import UIKit
import RxSwift
import RxDataSources

class SearchViewController: CachopoViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, Artist>>()
    
    
    
    
    
    
    
    
    private func search(searchText:String) {
        dispatch(searchArtists(searchText))
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.rowHeight = 80
        
        rxStore.observable { $0.searchState }
            .distinctUntilChanged()
            .map {
                [SectionModel<String, Artist>(model: "", items: $0.artists)]
            }
            .bindTo(tableView.rx_itemsWithDataSource(dataSource))
            .addDisposableTo(disposeBag)
        
        dataSource.configureCell = {
            _, tableView, indexPath, artist in
            let cell = tableView.dequeueReusableCellWithIdentifier("searchResultCell", forIndexPath: indexPath) as! SearchResultCell
            
            cell.artist = artist
            cell.toggleFavoriteArtist = self.toggleFavoriteArtist
            
            return cell
        }
        
        searchBar.rx_text
            .throttle(0.3, scheduler: MainScheduler.instance)
            .subscribeNext(search)
            .addDisposableTo(disposeBag)
        
        rxStore.observable { $0.searchState }
            .map { $0.searchString }
            .distinctUntilChanged()
            .bindTo(searchBar.rx_text)
            .addDisposableTo(disposeBag)
    }
        
    @IBAction func done(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    private func toggleFavoriteArtist(artist:Artist)
    {
        dispatch(ToggleFavoriteArtist(artist: artist))
    }
}


