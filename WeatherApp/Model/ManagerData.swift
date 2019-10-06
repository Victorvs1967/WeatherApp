//
//  ManagerData.swift
//  WeatherApp
//
//  Created by Victor Smirnov on 19/08/2019.
//  Copyright © 2019 Victor Smirnov. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import RealmSwift

class ManagerData {
  
  func loadJSON(_ city: String, isWaiting: Bool = false) {
    
    let params = ["q": city, "appid": appid]
    
    let queue = DispatchQueue.global(qos: .utility)
    let semaphore = DispatchSemaphore(value: 0)
    
    // Get JSON from API url
    AF.request(url, parameters: params).validate().responseJSON(queue: queue) { response in
      
      switch response.result {
      case .success(let value):
        // Write to Realm DB
        do {
          let onlineWeather = WeatherData()
          let realm = try Realm()
          try realm.write {
            let json = JSON(value)
            let cityName = json["city"]["name"].stringValue
            
            if cityName.count != 0 {
              onlineWeather.city = cityName
              for (_, item) in json["list"] {
                let tmpTemp = Temp()
                tmpTemp.dt = item["dt_txt"].stringValue
                tmpTemp.t = item["main"]["temp"].doubleValue - 273.15
                tmpTemp.icon = item["weather"][0]["icon"].stringValue
                onlineWeather.tempList.append(tmpTemp)
              }
            }
            realm.add(onlineWeather, update: .modified)
            loadFlag = true as AnyObject?
          }
        } catch let error as NSError {
          print(error.localizedDescription)
          loadFlag = false as AnyObject?
        }
      case .failure(let error):
        print(error.localizedDescription)
        loadFlag = false as AnyObject?
      }
      if isWaiting {
        semaphore.signal()
      }
    }
    if isWaiting {
      semaphore.wait()
    }
  }
  
  func loadFromDB(_ city: String) -> Results<WeatherData>? {
    
    do {
      let data = try Realm().objects(WeatherData.self).filter("city BEGINSWITH %@", city)
      return data
    } catch let error as NSError {
      print(error.localizedDescription)
      return nil
    }
  }
  
  func loadCitiesFromDB() -> [String] {
    
    do {
      var cities: [String] = []
      let datas = try Realm().objects(WeatherData.self)
      
      for data in datas {
        cities.append(data.city)
      }
      return cities
    } catch let error as NSError {
      print(error.localizedDescription)
      return []
    }
  }
  
}


public func deleteDBfiles() {
  
  if let dbFile = Realm.Configuration.defaultConfiguration.fileURL {
    
    let dbFiles = [dbFile,
                   dbFile.appendingPathExtension("lock"),
                   dbFile.appendingPathExtension("note"),
                   dbFile.appendingPathExtension("management")
    ]
    
    for URL in dbFiles {
      
      do {
        try FileManager.default.removeItem(at: URL)
        print("DB file deleted...")
      } catch let error as NSError {
        print(error.localizedDescription)
      }
    }
  }
}


