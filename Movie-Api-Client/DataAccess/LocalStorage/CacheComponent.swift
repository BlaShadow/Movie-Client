//
//  CacheComponent.swift
//  Movie-Api-Client
//
//  Created by Blashadow on 7/18/18.
//  Copyright © 2018 Blashadow. All rights reserved.
//

import UIKit

class CacheItem : NSObject, NSCoding {
    let cacheIdentifier: String
    let cacheValue: AnyObject
    let cacheDate: Date
    
    required init?(coder aDecoder: NSCoder) {
        self.cacheIdentifier = aDecoder.decodeObject(forKey: "cacheIdentifier") as! String
        self.cacheValue = aDecoder.decodeObject(forKey: "cacheValue") as AnyObject
        self.cacheDate = aDecoder.decodeObject(forKey: "cacheDate") as! Date
    }
    
    init(identifier: String, value: AnyObject, date: Date) {
        self.cacheIdentifier = identifier
        self.cacheValue = value
        self.cacheDate = date
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.cacheIdentifier, forKey: "cacheIdentifier")
        aCoder.encode(self.cacheValue, forKey: "cacheValue")
        aCoder.encode(self.cacheDate, forKey: "cacheDate")
    }
}

class CacheComponent: NSObject {
    private static var sharedCacheComponent: CacheComponent = {
        return CacheComponent()
    }()
    
    class func shared() -> CacheComponent {
        return sharedCacheComponent
    }
    
    //Cache keys
    let kGenresCacheKey = "kGenresCacheKey"
    
    fileprivate func saveCacheItemIntoUserDefaults(cacheItem: CacheItem){
        let userDefaults = UserDefaults.standard
        let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: cacheItem)
        userDefaults.set(encodedData, forKey: cacheItem.cacheIdentifier)
        userDefaults.synchronize()
    }
    
    fileprivate func retrieveCacheItemWith(identifier key: String) -> CacheItem? {
        let userDefaults = UserDefaults.standard
        if let decoded = userDefaults.object(forKey: kGenresCacheKey) {
            return NSKeyedUnarchiver.unarchiveObject(with: decoded as! Data) as? CacheItem
        } else {
            return nil
        }
    }
    
    //Cache all genres
    var genres: [String: String]? {
        get{
            let cacheItem = self.retrieveCacheItemWith(identifier: kGenresCacheKey)
            
            if cacheItem == nil {
                return nil
            }
            
            let deltaResult = Date().timeIntervalSince1970 - (cacheItem?.cacheDate.timeIntervalSince1970)!
            let hours = deltaResult / 3600
            
            if hours > 48 {
                return nil
            }
            
            return cacheItem?.cacheValue as? [String: String]
        }
        
        set {
            let cacheItem = CacheItem(identifier: kGenresCacheKey, value: newValue as AnyObject, date: Date())
            
            self.saveCacheItemIntoUserDefaults(cacheItem: cacheItem)
        }
    }
}
