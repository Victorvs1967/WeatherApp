//
//  WeatherData.swift
//  WeatherApp
//
//  Created by Victor Smirnov on 20/08/2019.
//  Copyright © 2019 Victor Smirnov. All rights reserved.
//

import Foundation
import RealmSwift

class WeatherData: Object {
  
  @objc dynamic var city = ""
  var tempList = List<Temp>()
  
  override static func primaryKey() -> String? {
    return "city"
  }
  
}
