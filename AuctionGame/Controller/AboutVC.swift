//
//  AboutVC.swift
//  Auction Game
//
//  Created by Developer on 09.09.2020.
//  Copyright © 2020 Michael Karmanov. All rights reserved.
//

import UIKit

class PopAboutVC: UIViewController {

    @IBOutlet weak var note_version: UILabel!
    @IBOutlet weak var note_devMail: UILabel!
    @IBOutlet weak var btn_feedback: UIButton!
    @IBOutlet weak var btn_rateApp: UIButton!
    @IBOutlet weak var btn_close: UIButton!
    @IBAction func btn_close_Tap(_ sender: UIButton) {
        close()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    fileprivate func close()
    {
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0
        }, completion: {(finished : Bool) in
            if (finished)
            {
                self.view.isHidden = true
                self.dismiss(animated: false, completion: nil)
            }
        })
    }
}
