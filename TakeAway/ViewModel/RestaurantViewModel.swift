//
//  RestaurantViewModel.swift
//  TakeAway
//
//  Created by Sarosh Salman on 18.02.18.
//  Copyright © 2018 saroshmirza. All rights reserved.
//
import Foundation
import SwiftyJSON

protocol RestaurantViewDelegate {
    func onSortingChanged(value: Int) -> ()
    func addRemoveFavorite(value: Int) -> ()
    
}

class RestaurantViewModel {
    weak var view: RestaurantView?
    var restaurants: [Restaurant] = []
    var nonFavRestaurants: [Restaurant] = []
    var favRestaurants: [Restaurant] = []
    let pickerDataSource: [String] = ["Best Match", "Newest", "Rating Average", "Distance", "Popularity", "Avg Product Price", "Delivery Costs", "Minimum Cost"]
    let pickerDataValues: [String] = ["bestMatch", "newest", "ratingAverage", "distance", "popularity", "averageProductPrice", "deliveryCosts", "minCost"]
    let pickerTitle = "Sorting Options"
    var pickerValue = 0
    
    init (view: RestaurantView){
        self.view = view
        
        if let path = Bundle.main.path(forResource: "restaurants", ofType: "JSON") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSON(data: data, options: .mutableLeaves)
                
                let restaurantList = jsonResult["restaurants"]
                for (_,subJson):(String, JSON) in restaurantList {
                    
                    let sortingValues = subJson["sortingValues"]
                    
                    let name = subJson["name"].string
                    let status = subJson["status"].string
                    let favorite = false
                    
                    let bestMatch = sortingValues["bestMatch"].double
                    let newest = sortingValues["newest"].double
                    let ratingAverage = sortingValues["ratingAverage"].double
                    let distance = sortingValues["distance"].double
                    let popularity = sortingValues["popularity"].double
                    let averageProductPrice = sortingValues["averageProductPrice"].double
                    let deliveryCosts = sortingValues["deliveryCosts"].double
                    let minCost = sortingValues["minCost"].double
                    
                    let restaurant = Restaurant(name: name!, status: status!, favorite: favorite, bestMatch: bestMatch!, newest: newest!, ratingAverage: ratingAverage!, distance: distance!, popularity: popularity!, averageProductPrice: averageProductPrice!, deliveryCosts: deliveryCosts!, minCost: minCost!)
                    
                    restaurants.append(restaurant)
                }
                nonFavRestaurants = restaurants
                
                
            } catch {
                // handle error
            }
            
        }
        sortingOnOpeningState()
    }
}

extension RestaurantViewModel: RestaurantViewDelegate{
    func onSortingChanged(value: Int) {
        
        self.pickerValue = value
        let val = pickerDataValues[value]
        
        switch val {
        case "sortNewest":
            self.sortNewest()
        case "ratingAverage":
            self.sortRatingAverage()
        case "distance":
            self.sortDistance()
        case "popularity":
            self.sortPopularity()
        case "averageProductPrice":
            self.sortAvgProductPrice()
        case "deliveryCosts":
            self.sortDeliveryCost()
        case "minCost":
            self.sortMinCost()
        default:
            self.sortBestMatch()
        }
        
        self.sortingOnOpeningState()
        self.view?.reloadTableView()
    }
    
    func sortingOnOpeningState(){
        var openRestaurants: [Restaurant] = []
        var closedRestaurants: [Restaurant] = []
        var orderRestaurants: [Restaurant] = []
        var temporaryRestaurants: [Restaurant] = []
        
        for i in 0..<nonFavRestaurants.count{
            
            let restaurant = nonFavRestaurants[i]
            if(restaurant.status == "open"){
                openRestaurants.append(restaurant)
            }else if(restaurant.status == "closed"){
                closedRestaurants.append(restaurant)
            }else{
                orderRestaurants.append(restaurant)
            }
        }
        
        temporaryRestaurants.append(contentsOf: openRestaurants)
        temporaryRestaurants.append(contentsOf: orderRestaurants)
        temporaryRestaurants.append(contentsOf: closedRestaurants)
        
        nonFavRestaurants = temporaryRestaurants

        openRestaurants.removeAll()
        orderRestaurants.removeAll()
        closedRestaurants.removeAll()
        temporaryRestaurants.removeAll()

        for i in 0..<favRestaurants.count{
            
            let restaurant = favRestaurants[i]
            if(restaurant.status == "open"){
                openRestaurants.append(restaurant)
            }else if(restaurant.status == "closed"){
                closedRestaurants.append(restaurant)
            }else{
                orderRestaurants.append(restaurant)
            }
        }
        temporaryRestaurants.append(contentsOf: openRestaurants)
        temporaryRestaurants.append(contentsOf: orderRestaurants)
        temporaryRestaurants.append(contentsOf: closedRestaurants)

        favRestaurants = temporaryRestaurants
        restaurants = favRestaurants + nonFavRestaurants
        
    }
    
    func addRemoveFavorite(value: Int){
        if(restaurants[value].favorite)!{
           
            restaurants[value].favorite = false
            
            let res = restaurants[value]
            nonFavRestaurants.append(res)
            favRestaurants.remove(at: value)
            
            self.onSortingChanged(value: self.pickerValue)
        }else
        {
            let res = restaurants[value]
            
            nonFavRestaurants.remove(at: value-favRestaurants.count)
            favRestaurants.append(res)
            res.favorite = true
            
            self.onSortingChanged(value: self.pickerValue)
        }
        self.view?.reloadTableView()
    }

    
    func sortBestMatch(){
        nonFavRestaurants = nonFavRestaurants.sorted { $0.bestMatch! < $1.bestMatch! }
        favRestaurants = favRestaurants.sorted { $0.bestMatch! < $1.bestMatch! }
    }
    
    func sortNewest(){
        nonFavRestaurants = nonFavRestaurants.sorted { $0.newest! < $1.newest! }
        favRestaurants = favRestaurants.sorted { $0.newest! < $1.newest! }
    }
    
    func sortRatingAverage(){
        nonFavRestaurants = nonFavRestaurants.sorted { $0.ratingAverage! < $1.ratingAverage! }
        favRestaurants = favRestaurants.sorted { $0.ratingAverage! < $1.ratingAverage! }
    }
    
    func sortDistance(){
        nonFavRestaurants = nonFavRestaurants.sorted { $0.distance! < $1.distance! }
        favRestaurants = favRestaurants.sorted { $0.distance! < $1.distance! }
    }
    
    func sortPopularity(){
        nonFavRestaurants = nonFavRestaurants.sorted { $0.popularity! < $1.popularity! }
        favRestaurants = favRestaurants.sorted { $0.popularity! < $1.popularity! }
    }

    func sortAvgProductPrice(){
        nonFavRestaurants = nonFavRestaurants.sorted { $0.averageProductPrice! < $1.averageProductPrice! }
        favRestaurants = favRestaurants.sorted { $0.averageProductPrice! < $1.averageProductPrice! }
    }
    
    func sortDeliveryCost(){
        nonFavRestaurants = nonFavRestaurants.sorted { $0.deliveryCosts! < $1.deliveryCosts! }
        favRestaurants = favRestaurants.sorted { $0.deliveryCosts! < $1.deliveryCosts! }
    }
    
    func sortMinCost(){
        nonFavRestaurants = nonFavRestaurants.sorted { $0.minCost! < $1.minCost! }
        favRestaurants = favRestaurants.sorted { $0.minCost! < $1.minCost! }
    }

}
