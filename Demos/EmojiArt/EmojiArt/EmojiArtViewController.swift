//
//  EmojiArtViewController.swift
//  EmojiArt
//
//  Created by Mitko Nikolov on 9/17/19.
//  Copyright © 2019 Mitko Nikolov. All rights reserved.
//

import UIKit

class EmojiArtViewController: UIViewController, UIDropInteractionDelegate {

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
        self.emojiArtView.backgroundImage = image
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

  @IBOutlet weak var dropZone: UIView! {
    didSet {
      dropZone.addInteraction(UIDropInteraction(delegate: self))
    }
  }
  
  var imageFetcher: ImageFetcher!
  
  @IBOutlet weak var emojiArtView: EmojiArtView!
  
}
