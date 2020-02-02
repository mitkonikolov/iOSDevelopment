//
//  ImageGalleryCollectionViewController.swift
//  Image Gallery
//
//  Created by Mitko Nikolov on 9/27/19.
//  Copyright © 2019 Mitko Nikolov. All rights reserved.
//

import UIKit

class ImageGalleryViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDropDelegate, UICollectionViewDragDelegate {
  
  var images = [UIImage(named: "1")]
  let sections = 1
  let cellWidth = CGFloat(200)
  
  // MARK: Collection View Data Source Delegate
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return images.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    print("a cell is requested for \(indexPath.item)")
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageGalleryCell", for: indexPath)
    if let imageGalleryCell = cell as? ImageGalleryCollectionViewCell, indexPath.item < images.endIndex {
      imageGalleryCell.image = images[indexPath.item]
    }
    
    return cell
  }
    
  
  // MARK: Flow Layout Delegate Method
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let size = images[indexPath.item]?.size
    var height = CGFloat(420)
    if let h = size?.height, let w = size?.width {
      height = cellWidth * (h/w)
    }
    return CGSize(width: cellWidth, height: height)
  }
  
  
  // MARK: Collection View Drop Delegate
  func collectionView(_ collectionView: UICollectionView, canHandle session: UIDropSession) -> Bool {
    // local drop
    if session.localDragSession != nil {
      return session.canLoadObjects(ofClass: UIImage.self)
    }
    // the drag started in a different app
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
      if (item.sourceIndexPath != nil) {
        collectionView.performBatchUpdates({
          let image = self.images[item.sourceIndexPath!.item]
          self.images.remove(at: item.sourceIndexPath!.item)
          let destination = (coordinator.destinationIndexPath != nil) ? coordinator.destinationIndexPath!.item : images.endIndex
          self.images.insert(image, at: destination)
          
        }, completion: {res in collectionView.reloadData()})
      }
      else {
        let destinationIndexPath = IndexPath(item: images.endIndex, section: sections-1)
        let placeholder = UICollectionViewDropPlaceholder(insertionIndexPath: destinationIndexPath, reuseIdentifier: "DropPlaceholderCell")
        let dropPlaceholderContext = coordinator.drop(item.dragItem, to: placeholder)
        
        item.dragItem.itemProvider.loadObject(ofClass: NSURL.self, completionHandler:
          { (url, error) in
            if let normalizedURL = (url as? URL)?.imageURL {
              let task = URLSession.shared.dataTask(with: normalizedURL) { [weak self] (receivedData, response, error) in
                if error == nil {
                  DispatchQueue.main.async {
                    dropPlaceholderContext.commitInsertion { _ in
                      self?.images.append(UIImage(data: receivedData!))
                    }
                  }
                }
                else {
                  print("there was an error downloading the image \(error!)")
                  DispatchQueue.main.async {
                    dropPlaceholderContext.deletePlaceholder()
                  }
                }
              }
              task.resume()
            }
          })
      }
    }
  }
  
  
  // MARK: UICollectionViewDragDelegate
  func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
    if self.images[indexPath.item] != nil {
      let provider = NSItemProvider(object: self.images[indexPath.item]!)
      let dragItem = UIDragItem(itemProvider: provider)
      return [dragItem]
    }
    return []
  }
  
  
  
  @IBOutlet weak var ImageGalleryCollectionView: UICollectionView! {
    didSet {
      ImageGalleryCollectionView.dataSource = self
      ImageGalleryCollectionView.delegate = self
      ImageGalleryCollectionView.dropDelegate = self
      ImageGalleryCollectionView.dragDelegate = self
    }
  }
}
