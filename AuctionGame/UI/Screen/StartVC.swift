//
//  StartVC.swift
//  AuctionGame
//
//  Created by Developer on 09.09.2020.
//  Copyright © 2020 Michael Karmanov. All rights reserved.
//

import UIKit

class StartVC: UIViewController {
    
    @IBAction func bar_btn_bestScore_Tap(_ sender: UIBarButtonItem) {
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: PopBestScoreVC.className) as! PopBestScoreVC
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true)
    }
    @IBAction func bar_btn_about_Tap(_ sender: UIBarButtonItem) {
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: PopAboutVC.className) as! PopAboutVC
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true)
    }
    @IBOutlet weak var note_appTitle: UILabel!
    @IBOutlet weak var btn_start: UIButton!
    @IBAction func btn_start_Tap(_ sender: UIButton) {
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: GameVC.className) as! GameVC
        UIView.animate(withDuration: anim_timeinterval, animations:{
            self.view.transform = CGAffineTransform(scaleX: 4, y: 4)
            self.view.alpha = 0.0
            self.navigationController?.navigationBar.alpha = 0.0
        })
        {
            (finished) in
            if (finished)
            {
                self.navigationController?.pushViewController(vc, animated: false)
                self.view.transform = .identity
                self.view.alpha = 1.0
                self.navigationController?.navigationBar.alpha = 1.0
            }
        }
    }
    
    fileprivate let anim_timeinterval: TimeInterval = 0.4

    override func viewDidLoad() {
        super.viewDidLoad()
        localeUI()
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: anim_timeinterval) {
            self.navigationController?.navigationBar.transform = .identity
        }
    }
    
    fileprivate func localeUI()
    {
        btn_start.setTitle(R.string.localizable.generalStart(), for: .normal)
    }
    
    fileprivate func setupUI()
    {
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.transform = CGAffineTransform(translationX: 0, y: -(navigationController?.navigationBar.frame.height ?? 0) * 2)
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.barTintColor = UIColor(resource: R.color.bgPrimary)
            self.view.backgroundColor = UIColor(resource: R.color.bgPrimary)
        }
        btn_start.layer.cornerRadius = 8
        note_appTitle.layer.cornerRadius = 8
        note_appTitle.layer.masksToBounds = true
    }
}
