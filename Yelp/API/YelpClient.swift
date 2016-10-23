//
//  YelpClient.swift
//  Yelp
//
//  Created by Chau Vo on 10/17/16.
//  Copyright © 2016 CoderSchool. All rights reserved.
//

import AFNetworking
import BDBOAuth1Manager

// You can register for Yelp API keys here: http://www.yelp.com/developers/manage_api_keys
let YELP_CONSUMER_KEY = "SpmE5nUarv0QwhTT_zEV4Q"
let YELP_CONSUMER_SECRET = "GX10liiBZyOpaZgGdpcxixOs8DU"
let YELP_TOKEN = "eqVTvUvuqzTc4vltnnxuPRa1d2sO5eQn"
let YELP_TOKEN_SECRET = "QdCSmGO1Nf0WftqR8WR8csxYfhU"
let YELP_BASE_URL = URL(string: "https://api.yelp.com/v2/")

enum YelpSortMode: Int {
    case bestMatched = 0, distance, highestRated
}

class YelpClient: BDBOAuth1RequestOperationManager {
    static var _shared: YelpClient?
    
    static func shared() -> YelpClient! {
        if _shared == nil {
            _shared = YelpClient()
        }
        return _shared
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(){
        super.init(baseURL: YELP_BASE_URL, consumerKey: YELP_CONSUMER_KEY, consumerSecret: YELP_CONSUMER_SECRET)
        let token = BDBOAuth1Credential(token: YELP_TOKEN, secret: YELP_TOKEN_SECRET, expiration: nil)
        self.requestSerializer.saveAccessToken(token)
    }
    
    func searchUsingBusinessFilters(completion: @escaping ([Business]?, Error?) -> ()) -> AFHTTPRequestOperation {
        return search(completion: completion)
    }
    
    func search(with term: String, completion: @escaping ([Business]?, Error?) -> ()) -> AFHTTPRequestOperation {
        return search(with: term, sort: nil, categories: nil, deals: nil, completion: completion)
    }
    
    func search(with term: String, sort: YelpSortMode?, categories: [String]?, deals: Bool?, completion: @escaping ([Business]?, Error?) -> ()) -> AFHTTPRequestOperation {
        
         // For additional parameters, see http://www.yelp.com/developers/documentation/v2/search_api
         // Default the location to San Francisco
         var parameters: [String : AnyObject] = ["term": term as AnyObject, "ll": "37.785771,-122.406165" as AnyObject]
         
         if sort != nil {
         parameters["sort"] = sort!.rawValue as AnyObject?
         }
         
         if categories != nil && categories!.count > 0 {
         parameters["category_filter"] = (categories!).joined(separator: ",") as AnyObject?
         }
         
         if deals != nil {
         parameters["deals_filter"] = deals! as AnyObject?
         }
        
        return self.get("search", parameters: parameters, success: { (operation: AFHTTPRequestOperation, response: Any) in
            if let response = response as? NSDictionary {
                let dictionaries = response["businesses"] as? [NSDictionary]
                if dictionaries != nil {
                    completion(Business.businesses(array: dictionaries!), nil)
                }
            }
            }, failure: { (operation: AFHTTPRequestOperation?, error: Error) in
                completion(nil, error)
        })!
    }
    
    func search(completion: @escaping ([Business]?, Error?) -> ()) -> AFHTTPRequestOperation {
        let parameters = generateSearchParam()
        
        return self.get("search", parameters: parameters, success: { (operation: AFHTTPRequestOperation, response: Any) in
            if let response = response as? NSDictionary {
                let dictionaries = response["businesses"] as? [NSDictionary]
                if dictionaries != nil {
                    completion(Business.businesses(array: dictionaries!), nil)
                }
            }
            }, failure: { (operation: AFHTTPRequestOperation?, error: Error) in
                completion(nil, error)
        })!
    }
    
    // Helper method that constructs a dictionary of the query parameters used in the request to the Yelp API
    // For additional parameters, see http://www.yelp.com/developers/documentation/v2/search_api
    fileprivate func generateSearchParam() -> [String : AnyObject] {
        let filters = BusinessFilters.sharedInstance
        var params: [String : AnyObject] = [:]
        
        // Search term
        params["term"] = filters.searchTerm as AnyObject?
        
        // Geographic Coordinate
        params["ll"] = "37.785771,-122.406165" as AnyObject?
        
        // Category to filter search results with
        if let categories = filters.categories {
            if categories.count > 0 {
                params["category_filter"] = (categories).joined(separator: ",") as AnyObject?
            }
        }
        
        // Sort mode: 0=Best matched (default), 1=Distance, 2=Highest Rated
        if let sort = filters.sort {
            params["sort"] = sort as AnyObject?
        }
        
        // Search radius. The max value is 40000 meters (25 miles)
        if let radius = filters.radius {
            
            let selectedRadiusType = radius
            switch selectedRadiusType {
            case 0:
                break
            case 1:
                params["radius_filter"] = (0.3 * 1609.344) as AnyObject?
            case 2:
                params["radius_filter"] = (1 * 1609.344) as AnyObject?
            case 3:
                params["radius_filter"] = (5 * 1609.344) as AnyObject?
            case 4:
                params["radius_filter"] = (15 * 1609.344) as AnyObject?
            default:
                break
            }
        }
        
        // Deals filter
        if let deals = filters.deals {
            params["deals_filter"] = (deals as Bool?) as AnyObject?
        }
        
        print(params)
        
        return params
    }
    
    class func yelpCategories() -> [[String:String]]{
        return
            [["name" : "Afghan", "code": "afghani"],
             ["name" : "African", "code": "african"],
             ["name" : "American, New", "code": "newamerican"],
             ["name" : "American, Traditional", "code": "tradamerican"],
             ["name" : "Arabian", "code": "arabian"],
             ["name" : "Argentine", "code": "argentine"],
             ["name" : "Armenian", "code": "armenian"],
             ["name" : "Asian Fusion", "code": "asianfusion"],
             ["name" : "Asturian", "code": "asturian"],
             ["name" : "Australian", "code": "australian"],
             ["name" : "Austrian", "code": "austrian"],
             ["name" : "Baguettes", "code": "baguettes"]]
    }
}
