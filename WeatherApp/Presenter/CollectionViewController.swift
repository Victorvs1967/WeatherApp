//
//  CollectionViewController.swift
//  WeatherApp
//
//  Created by Victor Smirnov on 11/09/2019.
//  Copyright © 2019 Victor Smirnov. All rights reserved.
//

import UIKit
import RealmSwift

class CollectionViewController: UICollectionViewController {
  
  private let reuseIdentifier = "Cell"
  
  var city = City()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let data = ManagerData()
    
    self.navigationItem.title = city.name
    
    if let detail = data.loadFromDB(city.name)?.first {
      for tmpValue in detail.tempList {
        city.t.append(tmpValue.t)
        city.icons.append(tmpValue.icon)
        city.time.append(tmpValue.dt)
      }
    } else {
      messageAlert("Not weather forecast for this city", view: self)
    }
  }
  
  // MARK: UICollectionViewDataSource
  override func numberOfSections(in collectionView: UICollectionView) -> Int {
    // #warning Incomplete implementation, return the number of sections
    return 1
  }
  
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    // #warning Incomplete implementation, return the number of items
    return city.t.count
  }
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
    
    // Config the cell
    var label1 = UILabel()
    label1 = cell.viewWithTag(1) as! UILabel
    var imageView = UIImageView()
    imageView = cell.viewWithTag(2) as! UIImageView
    var label2 = UILabel()
    label2 = cell.viewWithTag(3) as! UILabel
    
    label1.text = String(Int(city.t[indexPath.row])) + "ºC"
    
    label2.text = city.time[indexPath.row]
    imageView.image = UIImage(named: city.icons[indexPath.row])
    
    return cell
  }
  
}
