//
//  Temp.swift
//  WeatherApp
//
//  Created by Victor Smirnov on 20/08/2019.
//  Copyright © 2019 Victor Smirnov. All rights reserved.
//

import Foundation
import RealmSwift

class Temp: Object {
  
  @objc dynamic var t: Double = 0
  @objc dynamic var icon: String = ""
  @objc dynamic var dt: String = ""
  
}
