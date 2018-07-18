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
    ///   - completion: response handle
    /// - Returns: http session
    func retrieveListOfMoviesForPage(page :NSInteger, withCompletion completion: @escaping (WebServiceResponse) -> Void) -> URLSessionTask
}
