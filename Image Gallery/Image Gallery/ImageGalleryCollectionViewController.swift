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
  let cellWidth = CGFloat(200)
  
  // MARK: Collection View Data Source Delegate
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
    
  
  // MARK: Flow Layout Delegate Method
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let size = image?.size
    var height = CGFloat(420)
    if let h = size?.height, let w = size?.width {
      height = cellWidth * (h/w)
    }
    return CGSize(width: cellWidth, height: height)
  }
  
  
  // MARK: Collection View Drop Delegate -
  func collectionView(_ collectionView: UICollectionView, canHandle session: UIDropSession) -> Bool {
    return session.canLoadObjects(ofClass: NSURL.self) &&
      session.canLoadObjects(ofClass: UIImage.self)
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      dropSessionDidUpdate session: UIDropSession,
                      withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
    return UICollectionViewDropProposal(operation: .copy)
  }
  
  func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
    for item in coordinator.items {
      item.dragItem.itemProvider.loadObject(ofClass: NSURL.self, completionHandler:
        { (url, error) in
          print("ImageGalleryViewController: collectionView performDropWith got \(url!)")
      })
    }
  }
  
  
  @IBOutlet weak var ImageGalleryCollectionView: UICollectionView! {
    didSet {
      ImageGalleryCollectionView.dataSource = self
      ImageGalleryCollectionView.delegate = self
      ImageGalleryCollectionView.dropDelegate = self
    }
  }
}
