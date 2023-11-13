//
//  PopGameScoreVC.swift
//  AuctionGame
//
//  Created by Developer on 09.09.2020.
//

import UIKit

protocol GameResultsCallback {
    func playAgain()
    func closeSession()
}

class PopGameScoreVC: UIViewController {
    
    @IBOutlet weak var insideView: UIView!
    @IBOutlet weak var imgView_newRecordIndicator: UIImageView!
    @IBOutlet weak var note_title: UILabel!
    @IBOutlet weak var note_score: UILabel!
    
    @IBOutlet weak var btn_playAgain: UIButton!
    @IBAction func btn_playAgain_Tap(_ sender: UIButton) {
        _delegate?.playAgain()
        close()
    }
    @IBOutlet weak var btn_close: UIButton!
    @IBAction func btn_close_Tap(_ sender: UIButton) {
        _delegate?.closeSession()
        close()
    }
    
    fileprivate var _delegate: GameResultsCallback?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        localeUI()
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        note_score.animateNumberEdit(begin: 0, end: Int64(auctionController.topScore), numberFormating: nil, animationInterval: 0.8, animationSteps: 20, completion: nil)
    }
    
    class func initializeVC(delegate: GameResultsCallback?) -> PopGameScoreVC
    {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: PopGameScoreVC.className) as! PopGameScoreVC
        vc._delegate = delegate
        return vc
    }
    
    fileprivate func localeUI()
    {
        if (auctionController.sessionTopScored)
        {
            note_title.text = R.string.localizable.gameNewRecord()
            imgView_newRecordIndicator.isHidden = false
        }
        else
        {
            note_title.text = R.string.localizable.gameScore()
            imgView_newRecordIndicator.isHidden = true
        }
        btn_playAgain.setTitle(R.string.localizable.gamePlayAgain(), for: .normal)
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
        btn_playAgain.layer.cornerRadius = 8
        
        note_score.layer.borderWidth = 1
        btn_close.layer.borderWidth = 1
        btn_playAgain.layer.borderWidth = 1
        
        btn_close.layer.borderColor = UIColor.red.cgColor
        
        if #available(iOS 13.0, *) {
            note_score.layer.borderColor = UIColor.label.cgColor
            btn_playAgain.layer.borderColor = UIColor.label.cgColor
        } else {
            note_score.layer.borderColor = UIColor.black.cgColor
            btn_playAgain.layer.borderColor = UIColor.black.cgColor
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

