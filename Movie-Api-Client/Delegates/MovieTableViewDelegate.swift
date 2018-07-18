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
}

class MovieTableViewDelegate: NSObject, UITableViewDelegate, UITableViewDataSource {
    
    //Const
    let kMovieCellIdentifier = "MOVIE_CELL"
    
    //List of movies
    private var movieList: [Movie]?
    private var moviesTableview: UITableView?
    private var responder: MovieTableViewDelegateResponder?
    
    init(with tableView: UITableView, andResponder responder: MovieTableViewDelegateResponder) {
        super.init()
        
        self.moviesTableview = tableView
        self.responder = responder
        
        self.setupTableView()
    }
    
    func updateTableView(with data: [Movie]){
        self.movieList = data
        
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
