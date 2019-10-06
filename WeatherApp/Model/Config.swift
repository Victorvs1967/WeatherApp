//
//  Config.swift
//  WeatherApp
//
//  Created by Victor Smirnov on 02/10/2019.
//  Copyright © 2019 Victor Smirnov. All rights reserved.
//

import Foundation

public var loadFlag: AnyObject? {
  get {
    return UserDefaults.standard.object(forKey: "flag") as AnyObject?
  }
  set {
    UserDefaults.standard.set(newValue, forKey: "flag")
    UserDefaults.standard.synchronize()
  }
}

public let url = "https://api.openweathermap.org/data/2.5/forecast"
public let appid = "e1f7d88c2aaf836677ef89091aeade4a"

