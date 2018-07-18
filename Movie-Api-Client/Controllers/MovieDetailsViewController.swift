//
//  MovieDetailsViewController.swift
//  Movie-Api-Client
//
//  Created by Blashadow on 7/17/18.
//  Copyright © 2018 Blashadow. All rights reserved.
//

import UIKit

class MovieDetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var movieDetailsTableView: UITableView!
    
    //Selected movie
    fileprivate var selectedMovie: Movie?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.movieDetailsTableView.tableFooterView = UIView()
        self.movieDetailsTableView.rowHeight = UITableViewAutomaticDimension
        self.movieDetailsTableView.estimatedRowHeight = 250.0
        self.movieDetailsTableView.separatorStyle = .none
        
        self.movieDetailsTableView.delegate = self
        self.movieDetailsTableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /// Setup view controller with a selected movie
    ///
    /// - Parameter movie: selected movie
    func setupViewController(with movie:Movie){
        self.selectedMovie = movie
    }
    
    //MARK: -
    //MARK: Table view delegate & Data Source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CELL", for: indexPath)
        
        let backdropImageView = cell.viewWithTag(1) as! UIImageView
        let posterImageView = cell.viewWithTag(2) as! UIImageView
        
        let titleLabel = cell.viewWithTag(3) as! UILabel
        let releaseLabel = cell.viewWithTag(4) as! UILabel
        let previewLabel = cell.viewWithTag(5) as! UILabel
        
        backdropImageView.sd_setImage(with: URL(string: (self.selectedMovie?.backDropImageUrl)!), completed: nil)
        posterImageView.sd_setImage(with: URL(string: (self.selectedMovie?.posterImageUrl)!), completed: nil)
        
        posterImageView.layer.borderWidth = 1.5
        posterImageView.layer.borderColor = UIColor.white.cgColor
        
        titleLabel.text = self.selectedMovie?.title
        releaseLabel.text = self.selectedMovie?.releaseDate.formatDateAsString()
        previewLabel.text = self.selectedMovie?.overview
        
        return cell
    }
}
