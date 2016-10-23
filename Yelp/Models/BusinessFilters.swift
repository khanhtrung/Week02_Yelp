//
//  BusinessFilters.swift
//  Yelp
//
//  Created by Tran Khanh Trung on 10/23/16.
//  Copyright © 2016 CoderSchool. All rights reserved.
//

import Foundation

// Model class that represents the user's search settings
class BusinessFilters {
    
    // Search term
    var searchTerm: String?
    
    // Sort mode: 0=Best matched (default), 1=Distance, 2=Highest Rated.
    var sort: Int?
    
    // Category to filter search results with
    var categories: [String]?
    
    // Search radius in meters. The max value is 40000 meters (25 miles)
    var radius: Int?

    // Whether to exclusively search for businesses with deals
    var deals: Bool?
    
    // Number of business results to return
    var limit: Int?
    
    static let sharedInstance = BusinessFilters()
    
    func clear(){
        searchTerm = nil
        sort = nil
        categories = nil
        radius = nil
        deals = nil
        limit = nil
    }
}
