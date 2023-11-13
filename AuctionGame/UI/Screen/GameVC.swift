//
//  GameVC.swift
//  AuctionGame
//
//  Created by Developer on 09.09.2020.
//  Copyright © 2020 Michael Karmanov. All rights reserved.
//

import UIKit

class GameVC: UIViewController {
    
    fileprivate static let _animationTimeInterval: TimeInterval = 0.4

    @IBAction func bar_btn_back_Tap(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBOutlet weak var pageControl_auctionRound: UIPageControl!
    @IBOutlet weak var note_imageTitle: UILabel!
    @IBOutlet weak var imgView_lot: UIImageView!
    @IBOutlet weak var note_imgDesc: UILabel!
    
    @IBOutlet weak var view_circleProgressBar: CircleProgressBar!
    @IBOutlet weak var note_pointsValue: UILabel!
    @IBOutlet weak var note_pointsDesc: UILabel!
    @IBOutlet weak var btn_nextLot: UIButton!
    @IBAction func btn_nextLot_Tap(_ sender: UIButton) {
        nextLot()
    }
    
    @IBOutlet weak var note_LotRealPrice: UILabel!
    @IBOutlet weak var tf_lotBetPrice: UITextField!
    @IBAction func tf_lotBetPrice_Edited(_ sender: UITextField) {
        var price: String = sender.text ?? "$0"
        btn_betLot.isEnabled = true
        if (price.count == 0)
        {
            sender.text = "$" + (sender.text ?? "0")
            return
        }
        price = price.replacingOccurrences(of: "$", with: "")
        price = price.replacingOccurrences(of: " ", with: "")
        if (price.count == 0)
        {
            sender.text = ""
            btn_betLot.isEnabled = false
            return
        }
        let num = UInt64(price) ?? 0
        price = PriceUtil.getFormattedPrice(num)
        sender.text = price
    }
    @IBOutlet weak var btn_betLot: UIButton!
    @IBAction func btn_betLot_Tap(_ sender: UIButton) {
        makeBet()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeKeyboardObservers()
        initializeKeyboardHideGestures()
        _ = auctionController.initNewSession(appProperties: appProperties)
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: GameVC._animationTimeInterval) {
            self.navigationController?.navigationBar.transform = .identity
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeKeyboardObservers()
    }
    
    fileprivate func setupUI()
    {
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.transform = CGAffineTransform(translationX: 0, y: -(self.navigationController?.navigationBar.frame.height ?? 0) * 2)
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.barTintColor = UIColor(resource: R.color.bgPrimary)
            self.view.backgroundColor = UIColor(resource: R.color.bgPrimary)
        }
        
        tf_lotBetPrice.delegate = self
        
        note_LotRealPrice.layer.cornerRadius = 8
        note_LotRealPrice.layer.masksToBounds = true
        imgView_lot.layer.cornerRadius = 8
        
        btn_nextLot.layer.cornerRadius = 8
        btn_betLot.layer.cornerRadius = 8
        btn_betLot.layer.borderWidth = 1
        if #available(iOS 13.0, *) {
            btn_betLot.layer.borderColor = UIColor.label.cgColor
        } else {
            btn_betLot.layer.borderColor = UIColor.black.cgColor
        }
        
        note_LotRealPrice.alpha = 0.0
        note_pointsValue.alpha = 0.0
        note_pointsValue.alpha = 0.0
        view_circleProgressBar.alpha = 0.0
        btn_betLot.isEnabled = false
        
        updateSessionUI()
    }
    
    fileprivate func updateSessionUI()
    {
        navigationItem.title = R.string.localizable.gameRound() + " " + String(auctionController.sessionLotIndex + 1) + "/" + String(auctionController.sessionLots.count)
        guard let safeLot = auctionController.currSessionLot else {
            note_imageTitle.text = "N/A"
            note_imageTitle.alpha = 0.5
            imgView_lot.image = UIImage(resource: R.image.appIconRounded)
            imgView_lot.alpha = 0.5
            note_imgDesc.text = "N/A"
            note_imgDesc.alpha = 0.5
            tf_lotBetPrice.text = ""
            btn_betLot.isHidden = false
            tf_lotBetPrice.isHidden = false
            return
        }
        if (auctionController.sessionLotIndex == 0)
        {
            note_imageTitle.text = safeLot.title
            note_imageTitle.alpha = 0.5
            imgView_lot.image = UIImage(data: auctionController.loadLotImage(safeLot) ?? Data())
            imgView_lot.alpha = 0.5
            note_imgDesc.text = safeLot.medium
            note_imgDesc.alpha = 0.5
            tf_lotBetPrice.text = ""
            btn_betLot.isHidden = false
            tf_lotBetPrice.isHidden = false
            UIView.animate(withDuration: GameVC._animationTimeInterval, animations: {
                self.note_imageTitle.alpha = 1.0
                self.imgView_lot.alpha = 1.0
                self.note_imgDesc.alpha = 1.0
                self.tf_lotBetPrice.alpha = 1.0
                self.note_LotRealPrice.alpha = 0
                self.view_circleProgressBar.alpha = 0
                self.note_pointsValue.alpha = 0
                self.note_pointsDesc.alpha = 0
                self.btn_nextLot.alpha = 0
                self.btn_betLot.alpha = 1.0
                self.pageControl_auctionRound.currentPage = auctionController.sessionLotIndex
            })
            {
                (finished) in
                if (finished)
                {
                    self.btn_nextLot.isHidden = true
                }
            }
        }
        else
        {
            let hideTransform = CGAffineTransform(translationX: -self.view.frame.width, y: 0)
            let preShowTransform = CGAffineTransform(translationX: self.view.frame.width, y: 0)
            let preShowHiddenTransform = CGAffineTransform(translationX: self.view.frame.width * 2, y: 0)
            UIView.animate(withDuration: GameVC._animationTimeInterval / 2, animations:
            {
                self.note_imageTitle.transform = hideTransform
                self.imgView_lot.transform = hideTransform
                self.note_LotRealPrice.transform = hideTransform
                self.note_imgDesc.transform = hideTransform
                self.note_pointsValue.transform = hideTransform
                self.note_pointsDesc.transform = hideTransform
                self.btn_nextLot.transform = hideTransform
                self.view_circleProgressBar.transform = hideTransform
            })
            {
                (finished) in
                if (finished)
                {
                    self.note_LotRealPrice.alpha = 0.0
                    self.note_LotRealPrice.transform = .identity
                    
                    self.view_circleProgressBar.alpha = 0.0
                    self.view_circleProgressBar.progress = 0
                    self.view_circleProgressBar.transform = .identity
                    
                    self.note_pointsValue.alpha = 0.0
                    self.note_pointsValue.text = ""
                    self.note_pointsValue.transform = .identity
                    
                    self.note_pointsDesc.alpha = 0.0
                    self.note_pointsDesc.transform = .identity
                    
                    self.btn_nextLot.isHidden = true
                    self.btn_nextLot.alpha = 0.0
                    self.btn_nextLot.transform = .identity
                    
                    self.btn_betLot.transform = preShowTransform
                    self.btn_betLot.isHidden = false
                    self.btn_betLot.alpha = 1.0
                    
                    self.tf_lotBetPrice.text = ""
                    self.tf_lotBetPrice.transform = preShowTransform
                    self.tf_lotBetPrice.isHidden = false
                    self.tf_lotBetPrice.alpha = 1.0
                    
                    self.note_imageTitle.transform = preShowHiddenTransform
                    self.note_imageTitle.text = safeLot.title
                    self.imgView_lot.transform = preShowHiddenTransform
                    self.imgView_lot.image = UIImage(data: auctionController.loadLotImage(safeLot) ?? Data())
                    self.note_imgDesc.transform = preShowHiddenTransform
                    self.note_imgDesc.text = safeLot.medium
                    UIView.animate(withDuration: GameVC._animationTimeInterval)
                    {
                        self.note_imageTitle.transform = .identity
                        self.imgView_lot.transform = .identity
                        self.note_imgDesc.transform = .identity
                        self.tf_lotBetPrice.transform = .identity
                        self.btn_betLot.transform = .identity
                        self.pageControl_auctionRound.currentPage = auctionController.sessionLotIndex
                    }
                }
            }
        }
    }
    
    fileprivate func nextLot()
    {
        if (auctionController.sessionOver)
        {
            let vc = PopGameScoreVC.initializeVC(delegate: self)
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true)
            return
        }
        updateSessionUI()
    }
    
    fileprivate func makeBet()
    {
        note_LotRealPrice.text = ""
        note_pointsValue.text = "0"
        var price = tf_lotBetPrice.text ?? "$0"
        price = price.replacingOccurrences(of: "$", with: "")
        price = price.replacingOccurrences(of: " ", with: "")
        let betPrice = UInt64(price) ?? 0
        UIView.animate(withDuration: GameVC._animationTimeInterval / 2, animations: {
            self.note_LotRealPrice.alpha = 1.0
            self.view_circleProgressBar.alpha = 1.0
            self.note_pointsValue.alpha = 1.0
            self.note_pointsDesc.alpha = 1.0
            self.tf_lotBetPrice.alpha = 0.0
            self.btn_betLot.alpha = 0.0
        })
        {
            (finished) in
            if (finished)
            {
                self.btn_betLot.isHidden = true
                self.btn_betLot.isEnabled = false
                self.tf_lotBetPrice.isHidden = true
                self.note_LotRealPrice.animateNumberEdit(begin: 0, end: Int64(auctionController.currSessionLot?.price ?? 0), numberFormating:
                {
                    number in
                    return PriceUtil.getFormattedPrice(UInt64(bitPattern: number))
                }, animationInterval: GameVC._animationTimeInterval * 2, animationSteps: 80)
                {
                    let currPoints = auctionController.betCurrLotPrice(betPrice)
                    self.view_circleProgressBar.setProgressAnimated(CGFloat(currPoints) / 10.0, animationInterval: GameVC._animationTimeInterval * 2, animationSteps: 20)
                    self.note_pointsValue.animateNumberEdit(begin: 0, end: Int64(currPoints), numberFormating: nil, animationInterval: GameVC._animationTimeInterval * 2, animationSteps: 20)
                    {
                        self.btn_nextLot.isHidden = false
                        UIView.animate(withDuration: GameVC._animationTimeInterval / 2)
                        {
                            self.btn_nextLot.alpha = 1.0
                        }
                    }
                }
            }
        }
    }
}

extension GameVC: UITextFieldDelegate
{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var price: String = textField.text ?? "$0"
        price = price.replacingOccurrences(of: "$", with: "")
        price = price.replacingOccurrences(of: " " , with: "")
        if (price.count == 19 && string != "") // 2^63
        {
            return false
        }
        return true
    }
}

extension GameVC: GameResultsCallback
{
    func playAgain() {
        _ = auctionController.initNewSession(appProperties: appProperties)
        updateSessionUI()
    }
    
    func closeSession() {
        self.navigationController?.popViewController(animated: true)
    }
}
