//
//  ImageViewController.swift
//  ImageGallery
//
//  Created by Mitko Nikolov on 9/7/19.
//  Copyright © 2019 Mitko Nikolov. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController, UIScrollViewDelegate {
  
  override func viewDidLoad() {
    super.viewDidLoad()
//    if imageURL == nil {
//      imageURL = URL(string: "https://upload.wikimedia.org/wikipedia/commons/c/cd/Stanford_Oval_May_2011_panorama.jpg")
//    }
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    // the imageView should be set up
    if imageView.image == nil {
      fetchImage()
    }
  }
  
  func viewForZooming(in scrollView: UIScrollView) -> UIView? {
    return imageView
  }
  
  var imageURL: URL? {
    didSet {
      // reset the image because it should be updated
      image = nil
      // the view managed by this viewController has a window only if it has
      // appeared and only then do we want to fetch the image
      if view.window != nil {
        fetchImage()
      }
    }
  }
  
  private var image: UIImage? {
    get {
      return imageView.image
    }
    
    set {
      imageView.image = newValue
      imageView.sizeToFit()
      scrollView?.contentSize = imageView.frame.size
      spinner?.stopAnimating()
    }
  }
  
  @IBOutlet weak var spinner: UIActivityIndicatorView!
  
  @IBOutlet weak var scrollView: UIScrollView! {
    didSet {
      scrollView.minimumZoomScale = 1/25
      scrollView.maximumZoomScale = 1.0
      scrollView.delegate = self
      scrollView.addSubview(imageView)
    }
  }
  
  var imageView = UIImageView()
  
  private func fetchImage() {
    // check if imageURL is nil
    if let url = imageURL {
      spinner.startAnimating()
      DispatchQueue.global(qos: .userInitiated).async { [weak self] in
        // urlContents is a bag of bits
        // try? set the result to nil if Data throws an exception and to a bag of
        // bits otherwise
        let urlContents = try? Data(contentsOf: url)
        // urlContents != nil
        // we need to check that the fetched url and the self?.imageURL is one and the same because we are running multithreaded code and by the time, this closure gets executed, it is possible that the imageURL might have been changed and a new image is being fetched or has been fetched so we don't want to update, unless we got the image that we are still looking for
        DispatchQueue.main.async {
          if let imageData = urlContents, url == self?.imageURL {
            self?.image = UIImage(data: imageData)
          }
        }
      }
    }
  }
  
}
