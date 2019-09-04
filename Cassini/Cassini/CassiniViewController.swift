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
                if let imageVC = segue.destination as? ImageViewController {
                    imageVC.imageURL = url
                    imageVC.title = (sender as? UIButton)?.currentTitle
                }
            }
        }
    }
    

}
