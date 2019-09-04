 //
//  ImageViewController.swift
//  Cassini
//
//  Created by XMX on 2019/08/27.
//  Copyright © 2019 XMX. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController, UIScrollViewDelegate {
    
    var imageURL: URL? {
        didSet {
            image = nil
            if view.window != nil { // If a view is now on screen, it will get a window
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
            // Every time set the imageView, resize it
            imageView.sizeToFit()
            // And then resize the content size to be equal to the imageView
            scrollView?.contentSize = imageView.frame.size // Mark scrollView as optional then this line will be ignored if scrollView is nil
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated) //
        if imageView.image == nil {
            fetchImage()
        }
    }
    
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView.minimumZoomScale = 1/25
            scrollView.maximumZoomScale = 1.0
            scrollView.delegate = self
            scrollView.addSubview(imageView)
        }
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView // It is the subview that we want to zoom in/out when we pinch
    }
    
    var imageView = UIImageView()
    
    // Fetch the image from internet by the imageURL
    private func fetchImage() {
        if let url = imageURL {
            let urlContents = try? Data(contentsOf: url)
            if let imageData = urlContents {
                 image = UIImage(data: imageData)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if imageURL == nil {
            imageURL = DemoURLs.stanford
        }
    }
    
}
