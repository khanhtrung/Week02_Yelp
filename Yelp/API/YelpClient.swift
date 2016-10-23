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
        print(parameters)
        
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
        print(parameters)
        
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
            params["radius_filter"] = radius as AnyObject?
        }
        
        // Deals filter
        if let deals = filters.deals {
            params["deals_filter"] = deals as AnyObject?
        }
        
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
             ["name" : "Baguettes", "code": "baguettes"],
             ["name" : "Bangladeshi", "code": "bangladeshi"],
             ["name" : "Barbeque", "code": "bbq"],
             ["name" : "Basque", "code": "basque"],
             ["name" : "Bavarian", "code": "bavarian"],
             ["name" : "Beer Garden", "code": "beergarden"],
             ["name" : "Beer Hall", "code": "beerhall"],
             ["name" : "Beisl", "code": "beisl"],
             ["name" : "Belgian", "code": "belgian"],
             ["name" : "Bistros", "code": "bistros"],
             ["name" : "Black Sea", "code": "blacksea"],
             ["name" : "Brasseries", "code": "brasseries"],
             ["name" : "Brazilian", "code": "brazilian"],
             ["name" : "Breakfast & Brunch", "code": "breakfast_brunch"],
             ["name" : "British", "code": "british"],
             ["name" : "Buffets", "code": "buffets"],
             ["name" : "Bulgarian", "code": "bulgarian"],
             ["name" : "Burgers", "code": "burgers"],
             ["name" : "Burmese", "code": "burmese"],
             ["name" : "Cafes", "code": "cafes"],
             ["name" : "Cafeteria", "code": "cafeteria"],
             ["name" : "Cajun/Creole", "code": "cajun"],
             ["name" : "Cambodian", "code": "cambodian"],
             ["name" : "Canadian", "code": "New)"],
             ["name" : "Canteen", "code": "canteen"],
             ["name" : "Caribbean", "code": "caribbean"],
             ["name" : "Catalan", "code": "catalan"],
             ["name" : "Chech", "code": "chech"],
             ["name" : "Cheesesteaks", "code": "cheesesteaks"],
             ["name" : "Chicken Shop", "code": "chickenshop"],
             ["name" : "Chicken Wings", "code": "chicken_wings"],
             ["name" : "Chilean", "code": "chilean"],
             ["name" : "Chinese", "code": "chinese"],
             ["name" : "Comfort Food", "code": "comfortfood"],
             ["name" : "Corsican", "code": "corsican"],
             ["name" : "Creperies", "code": "creperies"],
             ["name" : "Cuban", "code": "cuban"],
             ["name" : "Curry Sausage", "code": "currysausage"],
             ["name" : "Cypriot", "code": "cypriot"],
             ["name" : "Czech", "code": "czech"],
             ["name" : "Czech/Slovakian", "code": "czechslovakian"],
             ["name" : "Danish", "code": "danish"],
             ["name" : "Delis", "code": "delis"],
             ["name" : "Diners", "code": "diners"],
             ["name" : "Dumplings", "code": "dumplings"],
             ["name" : "Eastern European", "code": "eastern_european"],
             ["name" : "Ethiopian", "code": "ethiopian"],
             ["name" : "Fast Food", "code": "hotdogs"],
             ["name" : "Filipino", "code": "filipino"],
             ["name" : "Fish & Chips", "code": "fishnchips"],
             ["name" : "Fondue", "code": "fondue"],
             ["name" : "Food Court", "code": "food_court"],
             ["name" : "Food Stands", "code": "foodstands"],
             ["name" : "French", "code": "french"],
             ["name" : "French Southwest", "code": "sud_ouest"],
             ["name" : "Galician", "code": "galician"],
             ["name" : "Gastropubs", "code": "gastropubs"],
             ["name" : "Georgian", "code": "georgian"],
             ["name" : "German", "code": "german"],
             ["name" : "Giblets", "code": "giblets"],
             ["name" : "Gluten-Free", "code": "gluten_free"],
             ["name" : "Greek", "code": "greek"],
             ["name" : "Halal", "code": "halal"],
             ["name" : "Hawaiian", "code": "hawaiian"],
             ["name" : "Heuriger", "code": "heuriger"],
             ["name" : "Himalayan/Nepalese", "code": "himalayan"],
             ["name" : "Hong Kong Style Cafe", "code": "hkcafe"],
             ["name" : "Hot Dogs", "code": "hotdog"],
             ["name" : "Hot Pot", "code": "hotpot"],
             ["name" : "Hungarian", "code": "hungarian"],
             ["name" : "Iberian", "code": "iberian"],
             ["name" : "Indian", "code": "indpak"],
             ["name" : "Indonesian", "code": "indonesian"],
             ["name" : "International", "code": "international"],
             ["name" : "Irish", "code": "irish"],
             ["name" : "Island Pub", "code": "island_pub"],
             ["name" : "Israeli", "code": "israeli"],
             ["name" : "Italian", "code": "italian"],
             ["name" : "Japanese", "code": "japanese"],
             ["name" : "Jewish", "code": "jewish"],
             ["name" : "Kebab", "code": "kebab"],
             ["name" : "Korean", "code": "korean"],
             ["name" : "Kosher", "code": "kosher"],
             ["name" : "Kurdish", "code": "kurdish"],
             ["name" : "Laos", "code": "laos"],
             ["name" : "Laotian", "code": "laotian"],
             ["name" : "Latin American", "code": "latin"],
             ["name" : "Live/Raw Food", "code": "raw_food"],
             ["name" : "Lyonnais", "code": "lyonnais"],
             ["name" : "Malaysian", "code": "malaysian"],
             ["name" : "Meatballs", "code": "meatballs"],
             ["name" : "Mediterranean", "code": "mediterranean"],
             ["name" : "Mexican", "code": "mexican"],
             ["name" : "Middle Eastern", "code": "mideastern"],
             ["name" : "Milk Bars", "code": "milkbars"],
             ["name" : "Modern Australian", "code": "modern_australian"],
             ["name" : "Modern European", "code": "modern_european"],
             ["name" : "Mongolian", "code": "mongolian"],
             ["name" : "Moroccan", "code": "moroccan"],
             ["name" : "New Zealand", "code": "newzealand"],
             ["name" : "Night Food", "code": "nightfood"],
             ["name" : "Norcinerie", "code": "norcinerie"],
             ["name" : "Open Sandwiches", "code": "opensandwiches"],
             ["name" : "Oriental", "code": "oriental"],
             ["name" : "Pakistani", "code": "pakistani"],
             ["name" : "Parent Cafes", "code": "eltern_cafes"],
             ["name" : "Parma", "code": "parma"],
             ["name" : "Persian/Iranian", "code": "persian"],
             ["name" : "Peruvian", "code": "peruvian"],
             ["name" : "Pita", "code": "pita"],
             ["name" : "Pizza", "code": "pizza"],
             ["name" : "Polish", "code": "polish"],
             ["name" : "Portuguese", "code": "portuguese"],
             ["name" : "Potatoes", "code": "potatoes"],
             ["name" : "Poutineries", "code": "poutineries"],
             ["name" : "Pub Food", "code": "pubfood"],
             ["name" : "Rice", "code": "riceshop"],
             ["name" : "Romanian", "code": "romanian"],
             ["name" : "Rotisserie Chicken", "code": "rotisserie_chicken"],
             ["name" : "Rumanian", "code": "rumanian"],
             ["name" : "Russian", "code": "russian"],
             ["name" : "Salad", "code": "salad"],
             ["name" : "Sandwiches", "code": "sandwiches"],
             ["name" : "Scandinavian", "code": "scandinavian"],
             ["name" : "Scottish", "code": "scottish"],
             ["name" : "Seafood", "code": "seafood"],
             ["name" : "Serbo Croatian", "code": "serbocroatian"],
             ["name" : "Signature Cuisine", "code": "signature_cuisine"],
             ["name" : "Singaporean", "code": "singaporean"],
             ["name" : "Slovakian", "code": "slovakian"],
             ["name" : "Soul Food", "code": "soulfood"],
             ["name" : "Soup", "code": "soup"],
             ["name" : "Southern", "code": "southern"],
             ["name" : "Spanish", "code": "spanish"],
             ["name" : "Steakhouses", "code": "steak"],
             ["name" : "Sushi Bars", "code": "sushi"],
             ["name" : "Swabian", "code": "swabian"],
             ["name" : "Swedish", "code": "swedish"],
             ["name" : "Swiss Food", "code": "swissfood"],
             ["name" : "Tabernas", "code": "tabernas"],
             ["name" : "Taiwanese", "code": "taiwanese"],
             ["name" : "Tapas Bars", "code": "tapas"],
             ["name" : "Tapas/Small Plates", "code": "tapasmallplates"],
             ["name" : "Tex-Mex", "code": "tex-mex"],
             ["name" : "Thai", "code": "thai"],
             ["name" : "Traditional Norwegian", "code": "norwegian"],
             ["name" : "Traditional Swedish", "code": "traditional_swedish"],
             ["name" : "Trattorie", "code": "trattorie"],
             ["name" : "Turkish", "code": "turkish"],
             ["name" : "Ukrainian", "code": "ukrainian"],
             ["name" : "Uzbek", "code": "uzbek"],
             ["name" : "Vegan", "code": "vegan"],
             ["name" : "Vegetarian", "code": "vegetarian"],
             ["name" : "Venison", "code": "venison"],
             ["name" : "Vietnamese", "code": "vietnamese"],
             ["name" : "Wok", "code": "wok"],
             ["name" : "Wraps", "code": "wraps"],
             ["name" : "Yugoslav", "code": "yugoslav"]]
    }
}
