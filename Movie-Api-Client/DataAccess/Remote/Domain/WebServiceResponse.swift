//
//  WebServiceResponse.swift
//  Movie-Api-Client
//
//  Created by Blashadow on 7/17/18.
//  Copyright © 2018 Blashadow. All rights reserved.
//

import UIKit

class WebServiceResponse: NSObject {
    /// HTTP request response code (200, 404, 500, ...)
    let statusCode: NSInteger
    
    /// Response Content (payload)
    let responseContent: AnyObject
    
    /// Init web service response object with basic info
    ///
    /// - Parameters:
    ///   - statusCode: response code
    ///   - content: payload
    init(withStatusCode code: NSInteger, content: AnyObject) {
        self.statusCode = code
        self.responseContent = content
    }
}
