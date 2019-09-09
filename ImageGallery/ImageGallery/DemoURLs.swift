//
//  DemoURLs.swift
//  ImageGallery
//
//  Created by Mitko Nikolov on 9/8/19.
//  Copyright © 2019 Mitko Nikolov. All rights reserved.
//

import Foundation

struct DemoURLs {
  
  static var NASA:[String:URL] {
    let NASAURLStrings = [
      "Cassini": "https://solarsystem.nasa.gov/system/resources/detail_files/17634_PIA21440.jpg",
      "Earth": "https://earthobservatory.nasa.gov/resources/blogs/earthday_day_lrg.jpg",
      "Saturn": "https://external-preview.redd.it/Q04Dbdw82eS2qmNrODN0XbGFpGX--lJrpyKQ-uOCh9w.jpg?auto=webp&s=ff0301dfa9f5152b5948fb136ceff6a45e4b2fd4"
    ]
    var urls = Dictionary<String, URL>()
    for (key, value) in NASAURLStrings {
      urls[key] = URL(string: value)
    }
    return urls
  }
}
