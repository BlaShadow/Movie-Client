//
//  MovieApiClientProtocol.swift
//  Movie-Api-Client
//
//  Created by Blashadow on 7/17/18.
//  Copyright © 2018 Blashadow. All rights reserved.
//

import UIKit

protocol MovieApiClientProtocol {
    
    /// Retrieve a list of movies
    ///
    /// - Parameters:
    ///   - page: page number
    ///   - completion: response handler
    /// - Returns: http session task
    func retrieveListOfMoviesForPage(page :NSInteger, withCompletion completion: @escaping (WebServiceResponse) -> Void) -> URLSessionTask
    
    /// Search movies using text
    ///
    /// - Parameters:
    ///   - criteria: Text criteria
    ///   - page: page number
    ///   - completion: response handler
    /// - Returns: http session task
    func searchMoviesWithTextCriteria(criteria: String, page :NSInteger, withCompletion completion: @escaping (WebServiceResponse) -> Void) -> URLSessionTask
    
    /// Fetch all genres availables
    ///
    /// - Parameter completion: response handler
    /// - Returns: http session task
    func retrieveAllGenres(withCompletion completion: @escaping (WebServiceResponse) -> Void) -> URLSessionTask
}
