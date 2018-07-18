//
//  MovieResponsehandler.swift
//  Movie-Api-Client
//
//  Created by Blashadow on 7/17/18.
//  Copyright © 2018 Blashadow. All rights reserved.
//

import UIKit

class MovieResponsehandler: NSObject {
    private static var sharedMovieResponsehandler: MovieResponsehandler = {
        return MovieResponsehandler()
    }()
    
    class func shared() -> MovieResponsehandler {
        return sharedMovieResponsehandler
    }
    
    func retrieveListOfMovies(ForPage page: NSInteger, withCompletion completion: @escaping (NSError?, [Movie]?) -> Void) -> URLSessionTask {
        let task = WebServiceClient.shared().retrieveListOfMoviesForPage(page: page) { (response) in
            var result: [Movie]?
            var error: NSError?
            
            if response.statusCode == 200 {
                guard let content: Dictionary<String, AnyObject> = response.responseContent as? Dictionary<String, AnyObject> else {
                    DispatchQueue.main.async {
                        completion(error, result)
                    }
                    
                    return
                }
                
                guard let rawResults: [Dictionary<String, AnyObject>] = content["results"] as? [Dictionary<String, AnyObject>] else {
                    DispatchQueue.main.async {
                        completion(error, result)
                    }
                    
                    return
                }
                
                result = self.parseListOfMovies(rawData: rawResults)
            } else {
                error = NSError(domain: "movie", code: 0, userInfo: ["errorDescription": "Unkown error"])
            }
            
            DispatchQueue.main.async {
                completion(error, result)
            }
        }
        
        return task
    }
    
    fileprivate func parseListOfMovies(rawData: [Dictionary<String, AnyObject>]) -> [Movie] {
        var result: [Movie] = []
        
        for item:Dictionary<String, AnyObject> in rawData {
            result.append(self.parseSingleMovieWith(rawItem: item))
        }
        
        return result
    }
    
    fileprivate func parseSingleMovieWith(rawItem item: Dictionary<String, AnyObject>) -> Movie {
        
        let identifier = item["id"]?.int64Value ?? 0
        let title = item["title"] as? String ?? ""
        let overview = item["overview"] as? String ?? ""
        let releaseDate = Date.dateWithString(value: item["release_date"]as? String ?? "")
        let backdropImagePath = item["backdrop_path"] as? String ?? ""
        let posterImagePath = item["poster_path"] as? String ?? ""
        let movieScore = NSNumber(value: (item["vote_average"]?.doubleValue ?? 0))
        
        let movie = Movie(identifier: identifier, title: title, overview: overview, releaseDate: releaseDate, movieScore: movieScore , backdropImage: backdropImagePath, posterImage: posterImagePath)
        
        return movie
    }
}
