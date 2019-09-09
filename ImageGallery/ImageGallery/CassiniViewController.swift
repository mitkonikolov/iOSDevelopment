//
//  CassiniViewController.swift
//  ImageGallery
//
//  Created by Mitko Nikolov on 9/8/19.
//  Copyright © 2019 Mitko Nikolov. All rights reserved.
//

import UIKit

class CassiniViewController: UIViewController {

  
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      if let identifier = segue.identifier {
        if let url = DemoURLs.NASA[identifier] {
          if let imageVC = segue.destination as? ImageViewController {
            imageVC.imageURL = url
            imageVC.title = (sender as? UIButton)?.currentTitle
          }
        }
      }
    }

}
