//
//  ConcentrationThemeChooserViewController.swift
//  Concentration
//
//  Created by XMX on 2019/08/16.
//  Copyright © 2019 XMX. All rights reserved.
//

import UIKit

class ConcentrationThemeChooserViewController: UIViewController, UISplitViewControllerDelegate {
    
    let themes = [
        "Sports":"⚽️🏀🏈⚾️🥎🎾🏐🏉🥏🎱🏓🏸",
        "Faces":"☺️😊😃😁😅😂😍🥰😘😗😋😝",
        "Animals":"🐶🐱🐭🐹🐰🦊🐻🐼🐨🐯🦁🐮",
    ]
    
    override func awakeFromNib() {
        splitViewController?.delegate = self
    }
    
    // UIViewController Collapse Secondary Onto Primary View Controller
    func splitViewController( // A func that asks: I'm adapting to the fact that I'm a splitViewController on an iPhone, and I want to collpase the detail, using the navigationController, on top of the primary (== the master). Should I do it?
        _ splitViewController: UISplitViewController,
        collapseSecondary secondaryViewController: UIViewController, // Detail
        onto primaryViewController: UIViewController // Master
    ) -> Bool { // Return false to say: I did not collpase this, please do it for me! And return true to say: Don't do it!
        
        // Attention! What collapsing dose is that put the detail onto the master!
        
        // For this Concentration game, we do not want the collapsing to happen if the theme has never been set
        if let cvc = secondaryViewController as? ConcentrationViewController {
            if cvc.theme == nil { // None theme set
                return true // If we don't want the collapsing to happen
            }
        }
        
        return false // Yes, please do that collapse
    }
    
    @IBAction func changeTheme(_ sender: Any) {
        if let cvc = splitViewDetailConcentrationViewController {
            if let themeName = (sender as? UIButton)?.currentTitle, let theme = themes[themeName] {
                cvc.theme = theme
            }
        } else if let cvc = lastSeguedToConcentrationViewController {
            if let themeName = (sender as? UIButton)?.currentTitle, let theme = themes[themeName] {
                cvc.theme = theme
            }
            navigationController?.pushViewController(cvc, animated: true)
        } else {
            performSegue(withIdentifier: "Choose Theme", sender: sender)
        }
    }
    
    private var splitViewDetailConcentrationViewController:ConcentrationViewController? {
        return splitViewController?.viewControllers.last as? ConcentrationViewController
    }
    
    // MARK: - Navigation
    
    private var lastSeguedToConcentrationViewController: ConcentrationViewController? // Hold the last cvc in the heap
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Choose Theme" {
            if let themeName = (sender as? UIButton)?.currentTitle, let theme = themes[themeName] {
                if let cvc = segue.destination as? ConcentrationViewController {
                    cvc.theme = theme
                    // Grab the last cvc so that the process of game won't be reset when the theme gets changed
                    lastSeguedToConcentrationViewController = cvc
                }
            }
        }
    }
    

}
