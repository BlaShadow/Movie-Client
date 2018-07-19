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
    fileprivate var task: URLSessionTask?
    fileprivate var currentTextCriteria: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Create table view delegate
        tableViewDelegate = MovieTableViewDelegate(with: self.tableViewSearchResult, andResponder: self)
        
        self.tableViewSearchResult.delegate = tableViewDelegate
        self.tableViewSearchResult.dataSource = tableViewDelegate
        
        self.searchBar.delegate = self
        
        self.searchBar.becomeFirstResponder()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let segueIdentifier = segue.identifier ?? ""
        
        if segueIdentifier.elementsEqual(kSearchMovieDetailsSegue) {
            let controller = segue.destination as! MovieDetailsViewController
            
            controller.setupViewController(with: sender as! Movie)
        }
    }
    
    fileprivate func searchMovieWith(text searchValue:String, page:NSInteger){
        //Save search criteria for paging
        self.currentTextCriteria = searchValue

        //Do not search for empty values
        if searchValue == ""{
            return
        }
        
        
        //Lock for another search
        self.tableViewDelegate?.isFetchingData = true
        
        //Hide keyboard
        self.searchBar.endEditing(true)
        
        self.task = DataAccessFacade.shared().searchMovieWithText(textCriteria: searchValue, page: page) { (error, movies) in
            self.tableViewDelegate?.isFetchingData = false
            
            if error != nil {
                
            } else {
                //Reload search table
                self.tableViewDelegate?.updateTableView(with: movies!)
            }
        }
    }
}

extension SearchViewController : MovieTableViewDelegateResponder {
    func fetchMoreDataWith(page requestedPage: NSInteger) {
        self.searchMovieWith(text: self.currentTextCriteria ?? "", page: requestedPage)
    }
    
    func didSelectMovie(with movie: Movie) {
        self.performSegue(withIdentifier: kSearchMovieDetailsSegue, sender: movie)
    }
}

extension SearchViewController : UISearchBarDelegate {
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.searchMovieWith(text: searchBar.text!, page: 1)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchMovieWith(text: searchBar.text!, page: 1)
    }
}
