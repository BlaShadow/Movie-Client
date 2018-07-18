//
//  ViewController.swift
//  Movie-Api-Client
//
//  Created by Blashadow on 7/17/18.
//  Copyright © 2018 Blashadow. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet fileprivate weak var moviesTableview: UITableView!
    
    let kMovieDetailsSegue = "MOVIE_DETAILS_SEGUE"
    
    fileprivate var movieList: [Movie]?
    fileprivate var fetchTask: URLSessionTask?
    fileprivate var movieDelegate: MovieTableViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Navigation bar style
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 229/255.0, green: 57/255.0, blue: 53/255.0, alpha: 0.5)
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.barStyle = .blackOpaque;
        
        //Setup movie delegate
        movieDelegate = MovieTableViewDelegate(with: self.moviesTableview, andResponder: self)
        
        self.moviesTableview.delegate = movieDelegate
        self.moviesTableview.dataSource = movieDelegate
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.fetchTask = DataAccessFacade.shared().listOfMovies(ForPage: 1) { (error, items) in
            if error != nil {
                
            } else {
                //Reload data
                self.movieDelegate?.updateTableView(with: items!)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let segueIdentifier = segue.identifier ?? ""
        
        if(segueIdentifier.elementsEqual(kMovieDetailsSegue)){
            let controller = segue.destination as! MovieDetailsViewController
            
            //Setup details view controller with a movie
            controller.setupViewController(with: sender as! Movie)
        }
    }
}

extension ViewController : MovieTableViewDelegateResponder {
    func didSelectMovie(with movie: Movie) {
        self.performSegue(withIdentifier: kMovieDetailsSegue, sender: movie)
    }
}
