//
//  Business.swift
//  Yelp
//
//  Created by Chau Vo on 10/17/16.
//  Copyright © 2016 CoderSchool. All rights reserved.
//

import Foundation

class Business: NSObject {
    let name: String?
    let address: String?
    let imageURL: URL?
    let categories: String?
    let distance: String?
    let ratingImageURL: URL?
    let reviewCount: NSNumber?
    
    init(dictionary: NSDictionary) {
        name = dictionary["name"] as? String
        
        let location = dictionary["location"] as? NSDictionary
        var address = ""
        if location != nil {
            let addressArray = location!["address"] as? NSArray
            if addressArray != nil && addressArray!.count > 0 {
                address = addressArray![0] as! String
            }
            
            let neighborhoods = location!["neighborhoods"] as? NSArray
            if neighborhoods != nil && neighborhoods!.count > 0 {
                if !address.isEmpty {
                    address += ", "
                }
                address += neighborhoods![0] as! String
            }
        }
        self.address = address
        
        let imageURLString = dictionary["image_url"] as? String
        if imageURLString != nil {
            imageURL = URL(string: imageURLString!)!
        } else {
            imageURL = nil
        }
        
        let categoriesArray = dictionary["categories"] as? [[String]]
        if categoriesArray != nil {
            var categoryNames = [String]()
            for category in categoriesArray! {
                let categoryName = category[0]
                categoryNames.append(categoryName)
            }
            categories = categoryNames.joined(separator: ", ")
        } else {
            categories = nil
        }
        
        let distanceMeters = dictionary["distance"] as? NSNumber
        if distanceMeters != nil {
            let milesPerMeter = 0.000621371
            distance = String(format: "%.2f mi", milesPerMeter * distanceMeters!.doubleValue)
        } else {
            distance = nil
        }
        
        let ratingImageURLString = dictionary["rating_img_url_large"] as? String
        if ratingImageURLString != nil {
            ratingImageURL = URL(string: ratingImageURLString!)
        } else {
            ratingImageURL = nil
        }
        
        reviewCount = dictionary["review_count"] as? NSNumber
    }
    
    class func businesses(array: [NSDictionary]) -> [Business] {
        var businesses = [Business]()
        for dictionary in array {
            let business = Business(dictionary: dictionary)
            businesses.append(business)
        }
        return businesses
    }
    
    class func search(with term: String, completion: @escaping ([Business]?, Error?) -> ()) {
        YelpClient.shared().search(with: term, completion: completion)
    }
    
    class func search(with term: String, sort: YelpSortMode?, categories: [String]?, deals: Bool?, completion: @escaping ([Business]?, Error?) -> ()) -> () {
        YelpClient.shared().search(with: term, sort: sort, categories: categories, deals: deals, completion: completion)
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
