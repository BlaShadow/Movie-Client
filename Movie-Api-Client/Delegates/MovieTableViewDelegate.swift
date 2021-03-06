//
//  MovieTableViewDelegate.swift
//  Movie-Api-Client
//
//  Created by Blashadow on 7/18/18.
//  Copyright © 2018 Blashadow. All rights reserved.
//

import UIKit

protocol MovieTableViewDelegateResponder {
    
    /// Method called after any movie been selected
    ///
    /// - Parameter movie: selected movie
    func didSelectMovie(with movie:Movie)
    
    
    /// Call this method when the user has come to the end of the table view
    /// and need to load more data
    ///
    /// - Parameter page: requested page
    func fetchMoreDataWith(page requestedPage:NSInteger)
}

class MovieTableViewDelegate: NSObject, UITableViewDelegate, UITableViewDataSource {
    
    //Const
    let kMovieCellIdentifier = "MOVIE_CELL"
    
    //List of movies
    private var movieList: [Movie]?
    private var moviesTableview: UITableView?
    private var responder: MovieTableViewDelegateResponder?
    
    var isFetchingData: Bool = false
    private var currentPage: NSInteger = 1
    private var shouldLoadMoreMovie: Bool = true
    
    init(with tableView: UITableView, andResponder responder: MovieTableViewDelegateResponder) {
        super.init()
        
        self.moviesTableview = tableView
        self.responder = responder
        
        self.setupTableView()
    }
    
    func updateTableView(with data: [Movie]){
        //Update page
        self.currentPage += 1
        
        //Movie list
        if self.movieList != nil && (self.movieList?.count)! > 0{
            self.movieList?.append(contentsOf: data)
        } else {
            self.movieList = data
            
            //if the data is less than 20 items, it's means there's no more movie
            self.shouldLoadMoreMovie = data.count == 20
        }
        
        //Reload data
        self.moviesTableview?.reloadData()
    }
    
    fileprivate func setupTableView(){
        self.moviesTableview?.tableFooterView = UIView()
        self.moviesTableview?.rowHeight = UITableViewAutomaticDimension
        self.moviesTableview?.estimatedRowHeight = 250.0
        self.moviesTableview?.contentInset = UIEdgeInsetsMake(10, 0, 0, 0)
        self.moviesTableview?.separatorStyle = .none
        
        //Register custom cell
        self.moviesTableview?.register(UINib(nibName: "MovieTableViewCell", bundle: nil), forCellReuseIdentifier: kMovieCellIdentifier)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let extraContentcontentOffset:CGFloat = 100
        let currentPosition = scrollView.contentOffset.y + extraContentcontentOffset
        let contentHeight = scrollView.contentSize.height - (self.moviesTableview?.frame.size.height)!
        
        if currentPosition >= contentHeight && self.isFetchingData == false {
            self.responder?.fetchMoreDataWith(page: self.currentPage)
        }
    }
    
    // MARK: -
    // MARK: Table view delegate & DataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.movieList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:MovieTableViewCell = tableView .dequeueReusableCell(withIdentifier: kMovieCellIdentifier, for: indexPath) as! MovieTableViewCell
        let movie = self.movieList![indexPath.row]
        
        //Setup cell
        cell.setupCell(with: movie)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movie = self.movieList![indexPath.row]
        
        self.responder?.didSelectMovie(with: movie)
    }
}
