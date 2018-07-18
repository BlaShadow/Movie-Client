//
//  Movie.swift
//  Movie-Api-Client
//
//  Created by Blashadow on 7/17/18.
//  Copyright © 2018 Blashadow. All rights reserved.
//

import UIKit

class Movie: NSObject {

    let identifier: Int64
    let title: String
    let overview: String
    let releaseDate: Date
    let movieScore: NSNumber
    let backdropImagePath: String
    let posterImagePath: String
    
    init(identifier: Int64, title: String, overview: String, releaseDate: Date, movieScore: NSNumber, backdropImage: String, posterImage: String) {
        self.identifier = identifier
        self.title = title
        self.overview = overview
        self.releaseDate = releaseDate
        self.movieScore = movieScore
        self.backdropImagePath = backdropImage
        self.posterImagePath = posterImage
    }
    
    var backDropImageUrl : String {
        get {
            return String(format: "https://image.tmdb.org/t/p/w780%@", self.backdropImagePath)
        }
    }
    
    var posterImageUrl: String {
        get {
            return String(format: "https://image.tmdb.org/t/p/w500%@", self.posterImagePath)
        }
    }
}
