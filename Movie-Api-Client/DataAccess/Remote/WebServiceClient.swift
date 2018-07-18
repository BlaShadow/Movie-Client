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
    
    // MARK: -
    // MARK: Movie Client Protocol
    
    func retrieveListOfMoviesForPage(page :NSInteger, withCompletion completion: @escaping (WebServiceResponse) -> Void) -> URLSessionTask {
        let url = self.url(withPath: "discover/movie")
        
        //Perform request
        return self.executeRequest(with: self.mutableGetRequest(withUrl: url), and: completion)
    }
    
    
    // MARK: -
    // MARK: Misc
    
    func url(withPath path:String) -> String{
        let apiKey = "1f54bd990f1cdfb230adb312546d765d"
        
        return String(format: "https://api.themoviedb.org/3/%@?api_key=%@&language=en-US", path, apiKey)
    }
    
    func mutableGetRequest(withUrl url:String) -> URLRequest {
        let request = NSMutableURLRequest(url: URL(string: url)!)
        
        request.httpMethod = "GET"
        
        request .setValue("application/json", forHTTPHeaderField: "Content-Type")
        request .setValue("application/json", forHTTPHeaderField: "Accept")
        
        return request as URLRequest
    }
}
