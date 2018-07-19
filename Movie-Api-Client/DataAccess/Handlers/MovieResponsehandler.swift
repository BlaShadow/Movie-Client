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
    
    func fetchAllGenres(with completion:@escaping (_ genres: [String: String]) -> Void) -> URLSessionTask {
        if let items = CacheComponent.shared().genres {
            completion(items)
            
            return URLSessionTask()
        }
        
        let task = WebServiceClient.shared().retrieveAllGenres { (response) in
            if(response.statusCode == 200){
                
                guard let rawData = response.responseContent as? [String: AnyObject] else  {
                    completion([:])
                    return;
                }
                
                guard let genres = rawData["genres"] as? [[String: AnyObject]] else {
                    completion([:])
                    return;
                }
                
                var cleanGenres: [String: String] = [:]
                
                genres.forEach({ (item) in
                    let key = String(item["id"] as! Int)
                    let value = String(item["name"] as! String)
                    
                    cleanGenres[key] = value
                })
                
                //Save movies genres into "cache"
                CacheComponent.shared().genres = cleanGenres
                
                //Respond back
                completion(cleanGenres)
            } else {
                completion([:])
            }
        }
        
        return task
    }
    
    func retrieveListOfMovies(ForPage page: NSInteger, withCompletion completion: @escaping (NSError?, [Movie]?) -> Void) -> URLSessionTask {
        let wsClient = WebServiceClient.shared()
        //Perform and handle list of movies result
        let task = wsClient.retrieveListOfMoviesForPage(page: page, withCompletion: self.handleResponderHandlerWithCompletion(completion))
        
        //Return task session
        return task
    }
    
    func searchMovieWith(text criteria: String, page: NSInteger, withCompletion completion: @escaping (NSError?, [Movie]?) -> Void) -> URLSessionTask {
        let wsClient = WebServiceClient.shared()
        
        //Perform and handle list of movies result
        let task = wsClient.searchMoviesWithTextCriteria(criteria: criteria, page:page, withCompletion: self.handleResponderHandlerWithCompletion(completion))
        
        //Return task session
        return task
    }
    
    func handleResponderHandlerWithCompletion(_ completion: @escaping (NSError?, [Movie]?) -> Void) -> (WebServiceResponse) -> Void {
        return { (response) in
            var result: [Movie]?
            var error: NSError?
            
            _ = self.fetchAllGenres(with: { (genres) in
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
                    
                    //Parse list of movie
                    result = self.parseListOfMovies(rawData: rawResults, genres: genres)
                } else {
                    error = NSError(domain: "movie", code: 0, userInfo: ["errorDescription": "Unkown error"])
                }
                
                DispatchQueue.main.async {
                    completion(error, result)
                }
            });
        }
    }
    
    fileprivate func parseListOfMovies(rawData: [Dictionary<String, AnyObject>], genres:[String: String]) -> [Movie] {
        var result: [Movie] = []
        
        for item:Dictionary<String, AnyObject> in rawData {
            result.append(self.parseSingleMovieWith(rawItem: item, genres: genres))
        }
        
        return result
    }
    
    fileprivate func parseSingleMovieWith(rawItem item: Dictionary<String, AnyObject>, genres:[String: String]) -> Movie {
        
        let identifier = item["id"]?.int64Value ?? 0
        let title = item["title"] as? String ?? ""
        let overview = item["overview"] as? String ?? ""
        let releaseDate = Date.dateWithString(value: item["release_date"]as? String ?? "")
        let backdropImagePath = item["backdrop_path"] as? String ?? ""
        let posterImagePath = item["poster_path"] as? String ?? ""
        let movieScore = NSNumber(value: (item["vote_average"]?.doubleValue ?? 0))
    
        let movieRawGenres = item["genre_ids"] as? [Int] ?? []
        
        let movieGenres = movieRawGenres.map { (genreId) -> String in
            let key = String(genreId)
            return genres[key] ?? ""
        }.joined(separator: ", ")
        
        let movie = Movie(identifier: identifier, title: title, overview: overview, releaseDate: releaseDate, movieScore: movieScore , backdropImage: backdropImagePath, posterImage: posterImagePath, genres: movieGenres)
        
        return movie
    }
}
