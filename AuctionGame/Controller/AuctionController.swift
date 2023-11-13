//
//  LotController.swift
//  AuctionGame
//
//  Created by developer on 04.11.2023.
//

import Foundation

class AuctionController {
    
    static let defaultSessionLotsCount: UInt8 = 9
    static let maxLotBetPoints: UInt16 = 1000
    
    fileprivate var _loadedLots: [String: Lot]
    var loadedLots: [String: Lot] {
        get {
            return _loadedLots
        }
    }
    fileprivate var _usedLots: Set<String>
    var usedLots: Set<String> {
        get {
            return Set<String>(_usedLots)
        }
    }
    var availableLots: [Lot] {
        get {
            var res: [Lot] = []
            for entry in _loadedLots {
                if (_usedLots.contains(entry.key)) {
                    continue
                }
                res.append(entry.value)
            }
            return res
        }
    }
    
    fileprivate(set) var topScore: UInt64
    
    fileprivate(set) var sessionLots: [Lot]
    fileprivate(set) var sessionLotIndex: Int
    fileprivate(set) var sessionTopScore: UInt64
    fileprivate(set) var sessionScore: UInt64
    var currSessionLot: Lot? {
        get {
            if (sessionLotIndex >= sessionLots.count) {
                return nil
            }
            return sessionLots[sessionLotIndex]
        }
    }
    var sessionOver: Bool {
        get {
            return sessionLots.count == sessionLotIndex
        }
    }
    var sessionTopScored: Bool {
        get {
            return sessionTopScore < sessionScore
        }
    }
    
    init() {
        _loadedLots = [:]
        _usedLots = Set<String>()
        
        sessionLots = []
        sessionLotIndex = 0
        sessionScore = 0
        sessionTopScore = 0
        topScore = 0
    }
    
    init(usedLots: [String], allLots: [Lot], topScore: UInt64) {
        _usedLots = Set<String>(usedLots)
        _loadedLots = [:]
        for lot in allLots {
            _loadedLots[lot.id] = lot
        }
        sessionLots = []
        sessionLotIndex = 0
        sessionScore = 0
        sessionTopScore = topScore
        self.topScore = topScore
    }
    
    func setLotsStorage(_ lots: [Lot]) {
        _loadedLots = [:]
        for lot in lots {
            _loadedLots[lot.id] = lot
        }
    }
    
    func resetTopScore(appProperties: AppProperties) {
        topScore = 0
        sessionTopScore = 0
        appProperties.topScore = 0
        appProperties.save()
    }
    
    func initNewSession(appProperties: AppProperties, lotsCount: UInt8 = AuctionController.defaultSessionLotsCount) -> Bool {
        sessionLotIndex = 0
        sessionScore = 0
        sessionTopScore = topScore
        if (appProperties.topScore < topScore) {
            appProperties.topScore = topScore
        }
        var available = availableLots
        if (available.isEmpty) {
            sessionLots.removeAll()
            appProperties.save()
            return false
        }
        var lots: [Lot] = []
        if (available.count <= lotsCount) {
            lots = available
        } else {
            while lots.count < lotsCount {
                let rndIndex = Int.random(in: 0...available.count - 1)
                lots.append(available[rndIndex])
                available.remove(at: rndIndex)
            }
        }
        sessionLots = lots
        for lot in sessionLots {
            _usedLots.insert(lot.id)
            appProperties.usedLots.append(lot.id)
        }
        appProperties.save()
        return true
    }
    
    func loadLotImage(_ lot: Lot) -> Data? {
        let bundle = Bundle(for: Self.self)
        guard let safeUrl = bundle.url(forResource: lot.img, withExtension: "jpg") else {return nil}
        return try? Data(contentsOf: safeUrl)
    }
    
    func betCurrLotPrice(_ price: UInt64) -> UInt64 {
        if (sessionOver) {
            return 0
        }
        let currLotPoints = calculateBetPriceScore(lotPrice: currSessionLot?.price ?? 0, betPrice: price)
        sessionScore += currLotPoints
        if (sessionScore > topScore) {
            topScore = sessionScore
        }
        sessionLotIndex += 1
        return currLotPoints
    }
    
    fileprivate func calculateBetPriceScore(lotPrice: UInt64, betPrice: UInt64) -> UInt64
    {
        var first = Double(betPrice)
        var second =  Double(lotPrice)
        if (betPrice > lotPrice)
        {
            first = Double(lotPrice)
            second =  Double(betPrice)
        }
        var score = first / second
        score *= 1000
        if (score > 65000) {
            score = Double(AuctionController.maxLotBetPoints)
        } else if (score < 0) {
            score = 0
        }
        return UInt64(score)
    }
}
