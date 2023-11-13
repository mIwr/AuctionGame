//
//  PopBestScoreVC.swift
//  AuctionGame
//
//  Created by Developer on 09.09.2020.
//

import UIKit

class PopBestScoreVC: UIViewController {
    
    @IBOutlet weak var insideView: UIView!
    @IBOutlet weak var note_title: UILabel!
    @IBOutlet weak var note_score: UILabel!
    @IBOutlet weak var btn_clearScore: UIButton!
    @IBAction func btn_clearScore_Tap(_ sender: UIButton) {
        note_score.animateNumberEdit(begin: Int64(auctionController.topScore), end: 0, numberFormating: nil, animationInterval: 0.8, animationSteps: 20, completion: nil)
        auctionController.resetTopScore(appProperties: appProperties)
    }
    @IBOutlet weak var btn_close: UIButton!
    @IBAction func btn_close_Tap(_ sender: UIButton) {
        close()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        localeUI()
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        note_score.animateNumberEdit(begin: 0, end: Int64(auctionController.topScore), numberFormating: nil, animationInterval: 0.8, animationSteps: 20, completion: nil)
    }
    
    fileprivate func localeUI()
    {
        note_title.text = R.string.localizable.generalBestScore()
        btn_clearScore.setTitle(R.string.localizable.generalClear(), for: .normal)
        btn_close.setTitle(R.string.localizable.generalClose(), for: .normal)
    }
    
    fileprivate func setupUI()
    {
        insideView.layer.cornerRadius = 8
        if #available(iOS 11.0, *) {
            view.backgroundColor = UIColor(resource: R.color.bgPopupOut)
            insideView.backgroundColor = UIColor(resource: R.color.bgPopup)
        }
        note_score.layer.cornerRadius = 8
        btn_close.layer.cornerRadius = 8
        btn_clearScore.layer.cornerRadius = 8
        
        note_score.layer.borderWidth = 1
        btn_close.layer.borderWidth = 1
        btn_clearScore.layer.borderWidth = 1
        
        btn_clearScore.layer.borderColor = UIColor.red.cgColor
        
        if #available(iOS 13.0, *) {
            note_score.layer.borderColor = UIColor.label.cgColor
            btn_close.layer.borderColor = UIColor.label.cgColor
        } else {
            note_score.layer.borderColor = UIColor.black.cgColor
            btn_close.layer.borderColor = UIColor.black.cgColor
        }
        note_score.text = "0"
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
