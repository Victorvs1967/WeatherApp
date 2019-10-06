//
//  ViewController.swift
//  WeatherApp
//
//  Created by Victor Smirnov on 15/08/2019.
//  Copyright © 2019 Victor Smirnov. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController: UITableViewController {
  
  private let reuseIdentifier = "Cell"
  
  let data = ManagerData()
  var isDeletin = false
  var currentAddAction: UIAlertAction!
  
  var city_list: [String] = [] {
    didSet {
      self.tableView.reloadData()
    }
  }
  
  @IBAction func addCity(_ sender: Any) {
    self.alertToAddCity()
  }
  
  @IBAction func deleteCity(_ sender: Any) {
    self.isDeletin = !self.isDeletin
    self.tableView.setEditing(self.isDeletin, animated: true)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if let _ = loadFlag {
      city_list = data.loadCitiesFromDB()
    } else {
      self.alertToAddCity()
    }
  }
  
  // MARK: - Navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
    if let destinationVC = segue.destination as? CollectionViewController {
      if let indexPath = tableView.indexPathForSelectedRow {
        let city = city_list[indexPath.row]
        destinationVC.city.name = city
      }
    }
  }
}

// MARK: - AlertControllers
extension ViewController {
  
  func alertToAddCity() {
    
    let alertController = UIAlertController(title: "Add City", message: "Write the name of city", preferredStyle: .alert)
    
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    let addACityAction = UIAlertAction(title: "Add City", style: .default) { (action) -> Void in
      
      if let cityName = alertController.textFields?.first?.text {
        if self.data.loadCitiesFromDB().contains(cityName) {
          messageAlert("City already exist!", view: self)
        } else {
          self.data.loadJSON(cityName, isWaiting: true)
          if loadFlag as! Bool {
            self.city_list.append(cityName)
          } else {
            messageAlert("Not weather forecast for this city", view: self)
          }
        }
      }
    }
    
    alertController.addAction(cancelAction)
    alertController.addAction(addACityAction)
    
    addACityAction.isEnabled = false
    self.currentAddAction = addACityAction
    
    alertController.addTextField { (textField) -> Void in
      
      textField.placeholder = "City Name"
      textField.addTarget(self, action: #selector(ViewController.addCityEnd(_:)), for: .editingChanged)
    }
    
    self.present(alertController, animated: true, completion: nil)
  }
  
  @objc func addCityEnd(_ textField: UITextField) {
    self.currentAddAction.isEnabled = !textField.text!.isEmpty
  }
}

// MARK: - TableView
extension ViewController {
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return city_list.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
    cell.textLabel?.text = city_list[indexPath.row]
    
    return cell
  }
  
  override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
    
    let deleteAction = UITableViewRowAction(style: .default, title: "Delete") { deleteAction, indexPath -> Void in
      
      if let cityToBeDelete = self.data.loadFromDB(self.city_list[indexPath.row]) {
        
        self.city_list.remove(at: indexPath.row)
        
        do {
          let realm = try Realm()
          
          try realm.write {
            realm.delete(cityToBeDelete)
          }
          
          for city in self.city_list {
            self.data.loadJSON(city)
          }
          
          self.tableView.setEditing(false, animated: true)
          
        } catch let error as NSError {
          print(error.localizedDescription)
        }
      }
    }
    return [deleteAction]
  }
  
}

public func messageAlert(_ message: String, view: UIViewController) {
  let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
  let action = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
  alert.addAction(action)
  view.present(alert, animated: true, completion: nil)
}
