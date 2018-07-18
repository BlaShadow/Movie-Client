//
//  ViewController.swift
//  Movie-Api-Client
//
//  Created by Blashadow on 7/17/18.
//  Copyright © 2018 Blashadow. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet fileprivate weak var moviesTableview: UITableView!
    
    let kMovieCellIdentifier = "MOVIE_CELL"
    let kMovieDetailsSegue = "MOVIE_DETAILS_SEGUE"
    
    fileprivate var movieList: [Movie]?
    fileprivate var fetchTask: URLSessionTask?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Navigation bar style
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 229/255.0, green: 57/255.0, blue: 53/255.0, alpha: 0.5)
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.barStyle = .blackOpaque;
        
        self.moviesTableview.delegate = self
        self.moviesTableview.dataSource = self
        
        self.moviesTableview.contentInset = UIEdgeInsetsMake(10, 0, 0, 0)
        self.moviesTableview.tableFooterView = UIView()
        self.moviesTableview.rowHeight = UITableViewAutomaticDimension
        self.moviesTableview.estimatedRowHeight = 250.0
        self.moviesTableview.separatorStyle = .none
        
        //Register custom cell
        self.moviesTableview .register(UINib(nibName: "MovieTableViewCell", bundle: nil), forCellReuseIdentifier: kMovieCellIdentifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.fetchTask = DataAccessFacade.shared().listOfMovies(ForPage: 1) { (error, items) in
            if error != nil {
                
            } else {
                //Save returned items
                self.movieList = items
                
                //Reload data
                self.moviesTableview.reloadData()
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier?.elementsEqual(kMovieDetailsSegue))!{
            let controller = segue.destination as! MovieDetailsViewController
            
            //Setup details view controller with a movie
            controller.setupViewController(with: sender as! Movie)
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
        
        self.performSegue(withIdentifier: kMovieDetailsSegue, sender: movie)
    }
}

