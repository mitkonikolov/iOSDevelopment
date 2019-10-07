//
//  ImageGalleryCollectionViewController.swift
//  Image Gallery
//
//  Created by Mitko Nikolov on 9/27/19.
//  Copyright © 2019 Mitko Nikolov. All rights reserved.
//

import UIKit

class ImageGalleryViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDropDelegate {
  
  var image = UIImage(named: "1")
  
  // Collection View Data Source Delegate: Begin ---
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 1
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageGalleryCell", for: indexPath)
    if let imageGalleryCell = cell as? ImageGalleryCollectionViewCell {
      
      imageGalleryCell.image = image
    }
    
    return cell
  }
  /// --- End
  
  
  // Flow Layout Delegate Methods: Begin ---
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let size = image?.size
    let width = CGFloat(120)
    var height = CGFloat(140)
    if let h = size?.height, let w = size?.width {
      height = width * (h/w)
    }
    return CGSize(width: width, height: height)
  }
  // --- End
  
  
  // Collection View Drop Delegate: Begin ---
  func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
    for item in coordinator.items {
      
    }
  }
  // --- End
  
  
  @IBOutlet weak var ImageGalleryCollectionView: UICollectionView! {
    didSet {
      ImageGalleryCollectionView.dataSource = self
      ImageGalleryCollectionView.delegate = self
      ImageGalleryCollectionView.dropDelegate = self
    }
  }
}
