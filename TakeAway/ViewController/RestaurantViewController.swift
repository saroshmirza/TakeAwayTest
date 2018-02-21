//
//  ViewController.swift
//  TakeAway
//
//  Created by Sarosh Salman on 18.02.18.
//  Copyright © 2018 saroshmirza. All rights reserved.
//

import UIKit
import ActionSheetPicker_3_0

protocol RestaurantView: class {
    func reloadTableView() -> ()
}

class RestaurantViewController: UIViewController {

    @IBOutlet weak var restaurantsTableView: UITableView!
    @IBOutlet weak var restaurantsSearchField: UISearchBar!
    
    var viewModel: RestaurantViewModel?
    
    let identifier = "restaurantCellIdentifier"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = RestaurantViewModel(view: self)
        self.setNavigationBar()
        
        let nib = UINib(nibName: "RestaurantCell", bundle: nil)
        restaurantsTableView.register(nib, forCellReuseIdentifier: identifier)
        
        
    }

    func setNavigationBar(){
        
        let filter = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(RestaurantViewController.openActionPicker))
        self.navigationItem.rightBarButtonItem = filter
    }
    
    @objc func favButtonPressed(sender: UIButton){
        viewModel?.addRemoveFavorite(value: sender.tag)
    }
    
    @objc func openActionPicker(_ sender: UIButton){
        ActionSheetStringPicker.show(withTitle: viewModel?.pickerTitle, rows: viewModel?.pickerDataSource, initialSelection: (viewModel?.pickerValue)!, doneBlock: {
            picker, value, index in
            self.viewModel?.onSortingChanged(value: value)
            
            return
        }, cancel: { ActionStringCancelBlock in return }, origin: sender)
        
    }
    
}

extension RestaurantViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (viewModel?.restaurants.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? RestaurantCell
        
        let restaurantData = viewModel?.restaurants[indexPath.row]
        cell?.configure(withData: restaurantData!)

        cell?.favButton.addTarget(self, action: #selector(favButtonPressed), for: .touchUpInside)
        cell?.favButton.tag = indexPath.row
        
        return cell!
        
    }

}
extension RestaurantViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 60;
    }

}

extension RestaurantViewController: RestaurantView{
    func reloadTableView() {
        restaurantsTableView.reloadData()
    }
}
