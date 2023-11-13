//
//  AboutVC.swift
//  AuctionGame
//
//  Created by Developer on 09.09.2020.


import UIKit
import MessageUI

class PopAboutVC: UIViewController {

    @IBOutlet weak var insideView: UIView!
    @IBOutlet weak var note_title: UILabel!
    @IBOutlet weak var note_appVersion: UILabel!
    @IBOutlet weak var btn_rateApp: UIButton!
    @IBAction func btn_rateApp_Tap(_ sender: UIButton) {
        rateApp()
    }
    @IBOutlet weak var btn_share: UIButton!
    @IBAction func btn_share_Tap(_ sender: UIButton) {
        share()
    }
    @IBOutlet weak var btn_close: UIButton!
    @IBAction func btn_close_Tap(_ sender: UIButton) {
        close()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        localeUI()
        insideView.layer.cornerRadius = 8
        if #available(iOS 11.0, *) {
            view.backgroundColor = UIColor(resource: R.color.bgPopupOut)
            insideView.backgroundColor = UIColor(resource: R.color.bgPopup)
        }
        btn_close.layer.cornerRadius = 8
        btn_close.layer.borderWidth = 1
        if #available(iOS 13.0, *) {
            btn_close.layer.borderColor = UIColor.label.cgColor
        } else {
            btn_close.layer.borderColor = UIColor.black.cgColor
        }
    }
    
    fileprivate func localeUI()
    {
        note_title.text = R.string.localizable.generalAbout()
        note_appVersion.text = "V " + (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0")
        btn_rateApp.setTitle(R.string.localizable.aboutRateApp(), for: .normal)
        btn_share.setTitle(R.string.localizable.generalShare(), for: .normal)
        btn_close.setTitle(R.string.localizable.generalClose(), for: .normal)
    }
    
    fileprivate func rateApp()
    {
        guard let url = URL(string: "https://itunes.apple.com/us/app/id" + Constants.appID + "?ls=1&mt=8&action=write-review") else {return}
        if (UIApplication.shared.canOpenURL(url))
        {
            UIApplication.shared.openURL(url)
        }  
    }
    
    fileprivate func share()
    {
        let activityVC = UIActivityViewController(activityItems: [R.string.localizable.aboutShareMessage() + " " + "https://itunes.apple.com/app/id" + Constants.appID], applicationActivities: nil)
        self.present(activityVC, animated: true, completion: nil)
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
