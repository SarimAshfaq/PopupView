//
//  ViewController.swift
//  PopupView
//
//  Created by Sarim Ashfaq on 05/03/2018.
//  Copyright © 2018 Sarim Ashfaq. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func showPopup(_ sender: UIButton) {
        let popup = PopupView("Success", "Showing your alert.'", #imageLiteral(resourceName: "brainstorm"))
        let action1 = PopupAction("Ok", .normal) {
            print("Ok button pressed")
        }
        let action2 = PopupAction("Cancel", .cancel) {
            print("Cancel button pressed")
        }
        popup.actions = [action1, action2]
        popup.show(in: self, true)
    }
    
}

