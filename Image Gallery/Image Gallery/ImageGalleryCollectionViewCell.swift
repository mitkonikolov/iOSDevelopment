//
//  ImageGalleryCollectionViewCell.swift
//  Image Gallery
//
//  Created by Mitko Nikolov on 9/27/19.
//  Copyright © 2019 Mitko Nikolov. All rights reserved.
//

import UIKit

class ImageGalleryCollectionViewCell: UICollectionViewCell {
  
  @IBOutlet weak var imageView: UIImageView! {
    didSet {
      imageView.sizeToFit()
    }
  }
  
  
}
