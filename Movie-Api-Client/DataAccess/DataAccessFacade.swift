//
//  DataAccessFacade.swift
//  Movie-Api-Client
//
//  Created by Blashadow on 7/17/18.
//  Copyright © 2018 Blashadow. All rights reserved.
//

import UIKit

class DataAccessFacade: NSObject {
    private static var sharedDataAccessFacade: DataAccessFacade = {
        return DataAccessFacade()
    }()
    
    class func shared() -> DataAccessFacade {
        return sharedDataAccessFacade
    }
    
    func listOfMovies(ForPage page:NSInteger, withCompletion completion: @escaping (NSError?, [Movie]?) -> Void) -> URLSessionTask {
        return MovieResponsehandler.shared().retrieveListOfMovies(ForPage:page, withCompletion:completion)
    }
}
