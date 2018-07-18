//
//  SearchViewController.swift
//  Movie-Api-Client
//
//  Created by Blashadow on 7/18/18.
//  Copyright © 2018 Blashadow. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

    let kSearchMovieDetailsSegue = "SEARCH_MOVIE_DETAILS"
    
    @IBOutlet fileprivate weak var searchBar: UISearchBar!
    @IBOutlet fileprivate weak var tableViewSearchResult: UITableView!
    
    fileprivate var tableViewDelegate: MovieTableViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Create table view delegate
        tableViewDelegate = MovieTableViewDelegate(with: self.tableViewSearchResult, andResponder: self)
        
        self.tableViewSearchResult.delegate = tableViewDelegate
        self.tableViewSearchResult.dataSource = tableViewDelegate
        
        self.searchBar.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.searchBar.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func searchMovieWith(text searchValue:String){
        print(searchValue)
    }
    
}

extension SearchViewController : MovieTableViewDelegateResponder {
    func didSelectMovie(with movie: Movie) {
        self.performSegue(withIdentifier: kSearchMovieDetailsSegue, sender: movie)
    }
}

extension SearchViewController : UISearchBarDelegate {
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.searchMovieWith(text: searchBar.text!)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchMovieWith(text: searchBar.text!)
    }
}
