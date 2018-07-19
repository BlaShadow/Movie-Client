//
//  WebServiceClient.swift
//  Movie-Api-Client
//
//  Created by Blashadow on 7/17/18.
//  Copyright © 2018 Blashadow. All rights reserved.
//

import UIKit

class WebServiceClient: NSObject, MovieApiClientProtocol {
    
    private static var sharedWebServiceClient: WebServiceClient = {
        return WebServiceClient()
    }()
    
    class func shared() -> WebServiceClient {
        return sharedWebServiceClient
    }
    
    fileprivate func executeRequest(with request: URLRequest, and completion: @escaping (WebServiceResponse) -> Void) -> URLSessionTask {
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            //Http data
            let httpResponse = response as! HTTPURLResponse
            let statusCode = httpResponse.statusCode
            var content: AnyObject? = nil
            
            if (data != nil) {
                content = try? JSONSerialization.jsonObject(with: data!, options: []) as AnyObject
            }
            
            //Respond back
            completion(WebServiceResponse.init(withStatusCode: statusCode, content: content!))
        }
        
        task.resume()
        
        return task
    }
}

// MARK: -
// MARK: Movie Client Protocol
extension WebServiceClient {
    
    func retrieveListOfMoviesForPage(page: NSInteger, withCompletion completion: @escaping (WebServiceResponse) -> Void) -> URLSessionTask {
        let url = self.url(withPath: "discover/movie", params: ["page": String(page)])
        
        //Perform request
        return self.executeRequest(with: self.mutableGetRequest(withUrl: url), and: completion)
    }
    
    func searchMoviesWithTextCriteria(criteria: String, page: NSInteger, withCompletion completion: @escaping (WebServiceResponse) -> Void) -> URLSessionTask {
        let url = self.url(withPath: "search/movie", params: ["query": criteria, "page": String(page)])
        
        //Perform request
        return self.executeRequest(with: self.mutableGetRequest(withUrl: url), and: completion)
    }
    
    func retrieveAllGenres(withCompletion completion: @escaping (WebServiceResponse) -> Void) -> URLSessionTask {
        let url = self.url(withPath: "genre/movie/list", params: [:])
        
        //Perform request
        return self.executeRequest(with: self.mutableGetRequest(withUrl: url), and: completion)
    }
}

// MARK: -
// MARK: Misc
extension WebServiceClient {
    
    func getEnvironmentVar(_ name: String) -> String {
        guard let rawValue = getenv(name) else { return "" }
        
        return String(utf8String: rawValue)!
    }
    
    func url(withPath path:String, params:[String: String]) -> URLComponents {
        let apiKey = self.getEnvironmentVar("API_KEY")
        var defaultParams: [String: String] = ["language": "en-US", "api_key": apiKey]
        
        //Merge params
        defaultParams.merge(params) { (_, new) in new }
        
        let queryItems = defaultParams.map { (key:String, value:String) -> URLQueryItem in
            return URLQueryItem(name: key, value: value)
        }
        
        var url = URLComponents(string: String(format: "https://api.themoviedb.org/3/%@", path))!
        url.queryItems = queryItems
        
        return url
    }
    
    func mutableGetRequest(withUrl urlComponent: URLComponents) -> URLRequest {
        let request = NSMutableURLRequest(url: urlComponent.url!)
        
        request.httpMethod = "GET"
        
        request .setValue("application/json", forHTTPHeaderField: "Content-Type")
        request .setValue("application/json", forHTTPHeaderField: "Accept")
        
        return request as URLRequest
    }
}
