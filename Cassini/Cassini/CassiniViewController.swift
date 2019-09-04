//
//  CassiniViewController.swift
//  Cassini
//
//  Created by XMX on 2019/09/4.
//  Copyright © 2019 XMX. All rights reserved.
//

import UIKit

class CassiniViewController: UIViewController {

    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if let url = DemoURLs.NASA[identifier] {
                if let imageVC = segue.destination.contents as? ImageViewController {
                    imageVC.imageURL = url
                    imageVC.title = (sender as? UIButton)?.currentTitle
                }
            }
        }
    }
    
}

extension UIViewController {
    var contents: UIViewController {
        if let navcon = self as? UINavigationController { // If it's a navcon
            return navcon.visibleViewController ?? self // the self will be returned if the navcon's visibleViewController is nil
        } else { // If it's not a navcon
            return self
        }
    }
}
