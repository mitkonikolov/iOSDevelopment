//
//  EmojiArtViewController.swift
//  EmojiArt
//
//  Created by Mitko Nikolov on 9/17/19.
//  Copyright © 2019 Mitko Nikolov. All rights reserved.
//

import UIKit

class EmojiArtViewController: UIViewController, UIDropInteractionDelegate, UIScrollViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDragDelegate, UICollectionViewDropDelegate {
  
  var emojiArtView = EmojiArtView()
  
  @IBOutlet weak var scrollViewHeight: NSLayoutConstraint!
  @IBOutlet weak var scrollViewWidth: NSLayoutConstraint!
  
  @IBOutlet weak var scrollView: UIScrollView! {
      didSet {
          scrollView.minimumZoomScale = 0.1
          scrollView.maximumZoomScale = 5.0
          scrollView.delegate = self
          scrollView.addSubview(emojiArtView)
      }
  }
  
  func scrollViewDidZoom(_ scrollView: UIScrollView) {
    scrollViewHeight.constant = scrollView.contentSize.height
    scrollViewWidth.constant = scrollView.contentSize.width
  }
  
  func viewForZooming(in scrollView: UIScrollView) -> UIView? {
      return emojiArtView
  }
  
  var emojiArtBackgroundImage: UIImage? {
      get {
          return emojiArtView.backgroundImage
      }
      set {
          scrollView?.zoomScale = 1
          emojiArtView.backgroundImage = newValue
          let size = newValue?.size ?? CGSize.zero
          emojiArtView.frame = CGRect(origin: CGPoint.zero, size: size)
          scrollView?.contentSize = size
        scrollViewHeight?.constant = size.height
        scrollViewWidth?.constant = size.width
          if let dropzone = self.dropZone, size.width > 0, size.height > 0 {
              scrollView?.zoomScale = max(dropzone.bounds.width / size.width, dropzone.bounds.height / size.height)
          }
      }
  }
  
  
  
  
  var emojis = "😀🎁✈️🎱🍎🐶🐝☕️🎼🚲♣️👨‍🎓✏️🌈🤡🎓👻☎️".map { String($0) }
  
  @IBOutlet weak var emojiCollectionView: UICollectionView! {
    didSet {
      emojiCollectionView.dataSource = self
      emojiCollectionView.delegate = self
      emojiCollectionView.dragDelegate = self
      emojiCollectionView.dropDelegate = self
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return emojis.count
  }
  
  private var font: UIFont {
    return UIFontMetrics(forTextStyle: .body).scaledFont(for: UIFont.preferredFont(forTextStyle: .body).withSize(64))
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EmojiCell", for: indexPath)
    
    if let emojiCell = cell as? EmojiCollectionViewCell {
      let text = NSAttributedString(string: emojis[indexPath.item], attributes: [.font: font])
      emojiCell.label.attributedText = text
    }
    
    return cell
  }
  
  // the initial things to be dragged
  func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
    // this allows me to tell the droppees (the collections accepting a drop) that this is a local drag and its context is the collection view. Thus I can know where the drag started from in case I would want to adjust my behavior based on the source of the drag.
    session.localContext = collectionView
    return dragItems(at: indexPath)
  }
  
  // add the emojis that were tapped while the drag was happening
  func collectionView(_ collectionView: UICollectionView, itemsForAddingTo session: UIDragSession, at indexPath: IndexPath, point: CGPoint) -> [UIDragItem] {
    return dragItems(at: indexPath)
  }
  
  private func dragItems(at indexPath: IndexPath) -> [UIDragItem] {
    if let attributedString = (emojiCollectionView.cellForItem(at: indexPath) as? EmojiCollectionViewCell)?.label.attributedText {
      let dragItem = UIDragItem(itemProvider: NSItemProvider(object: attributedString))
      // for drops that are local - within the app - the localObject will allow us to directly grab the object instead of asynchronously going through an NSItemProvider
      dragItem.localObject = attributedString
      return [dragItem]
    }
    else {
      return []
    }
  }
  
  
  func collectionView(_ collectionView: UICollectionView, canHandle session: UIDropSession) -> Bool {
    return session.canLoadObjects(ofClass: NSAttributedString.self)
  }
  
  func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
    // check that this is a local drag session and that the drag context (the source of the data) is really who I'd expect it to be which is myself. The drag started from me and end with me.
    let isSelf = (session.localDragSession?.localContext as? UICollectionView) == collectionView
    return UICollectionViewDropProposal(operation: isSelf ? .move : .copy, intent: .insertAtDestinationIndexPath)
  }

  func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
    let destinationIndexPath = coordinator.destinationIndexPath ?? IndexPath(item: 0, section: 0)
    for item in coordinator.items {
      // item.sourceIndexPath is only known if the item originated in the collection view
      if let sourceIndexPath = item.sourceIndexPath {
        if let attributedString = item.dragItem.localObject as? NSAttributedString {
          // we are updating our model and our view, but if we don't do all of these actions at once, our model (the array) will be changed first and then the view would still not have been changed and the two will mismatch. To prevent this, we use performBatchUpdates to perform all operations as one
          collectionView.performBatchUpdates({
            emojis.remove(at: sourceIndexPath.item)
            emojis.insert(attributedString.string, at: destinationIndexPath.item)
            collectionView.deleteItems(at: [sourceIndexPath])
            collectionView.insertItems(at: [destinationIndexPath])
          })
          // while moving the data happened above, this drop operation animates removing of the picture under your finger, removing the + sign, etc. - all the other things that are normally animated with a drag and drop
          coordinator.drop(item.dragItem, toItemAt: destinationIndexPath)
        }
      }
    }
  }
  
  
  
  
  
  
  
  
  
  
  var imageFetcher: ImageFetcher!

  
  @IBOutlet weak var dropZone: UIView! {
    didSet {
      dropZone.addInteraction(UIDropInteraction(delegate: self))
    }
  }

  // a drop interaction has started
  func dropInteraction(_ interaction: UIDropInteraction, canHandle session: UIDropSession) -> Bool {
    return session.canLoadObjects(ofClass: NSURL.self) && session.canLoadObjects(ofClass: UIImage.self)
  }
  
  // the element to be dropped has entered the bounds of the view, it has changed its location in the bounds of the view or more items have been added while it was in the bounds of the view
  func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
    return UIDropProposal(operation: .copy)
  }
  
  // perform the drop
  func dropInteraction(_ interaction: UIDropInteraction, performDrop session: UIDropSession) {
    imageFetcher = ImageFetcher() { (url, image) in
      // the ImageFetcher fetches the image on a different thread
      DispatchQueue.main.async {
        self.emojiArtBackgroundImage = image
      }
    }
    
    session.loadObjects(ofClass: NSURL.self) { nsurls in
      if let url = nsurls.first as? URL {
        self.imageFetcher.fetch(url)
      }
    }
    
    session.loadObjects(ofClass: UIImage.self) { images in
      // this is in the main queue
      // although images is supposed to be a UIImage, it still needs to be converted because its type is NSItemProviderReading
      // if the conversion fails, then nothing happens
      if let image = images.first as? UIImage {
        self.imageFetcher.backup = image
      }
    }
  }


  
}
