//
//  Restaurant.swift
//  TakeAway
//
//  Created by Sarosh Salman on 18.02.18.
//  Copyright © 2018 saroshmirza. All rights reserved.
//

class Restaurant{
    var name: String?
    var status: String?
    var favorite: Bool?
    
    var bestMatch: Double?
    var newest: Double?
    var ratingAverage: Double?
    var distance: Double?
    var popularity: Double?
    var averageProductPrice: Double?
    var deliveryCosts: Double?
    var minCost: Double?
    
    init(name: String, status: String, favorite: Bool, bestMatch: Double, newest: Double, ratingAverage: Double, distance: Double, popularity: Double, averageProductPrice: Double, deliveryCosts: Double, minCost: Double){
        
        self.name = name
        self.status = status
        self.favorite = favorite
        
        self.bestMatch = bestMatch
        self.newest = newest
        self.ratingAverage = ratingAverage
        self.distance = distance
        self.popularity = popularity
        self.averageProductPrice = averageProductPrice
        self.deliveryCosts = deliveryCosts
        self.minCost = minCost
        
    }
}
