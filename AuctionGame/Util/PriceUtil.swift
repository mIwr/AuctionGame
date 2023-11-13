//
//  PriceUtil.swift
//  AuctionGame
//
//  Created by Developer on 07.09.2020.
//

import Foundation

final class PriceUtil {
    
    fileprivate init() {}
    
    static func getFormattedPrice(_ price: UInt64, currency: String = "$") -> String
    {
        let chArr = Array(String(price))
        if (chArr.count == 0)
        {
            return currency + "0"
        }
        var res = ""
        for i in 0 ... chArr.count - 1
        {
            let index =  chArr.count - 1 - i
            if (i % 3 == 0 && i > 0)
            {
                res = " " + res
            }
            res = String(chArr[index]) + res
        }
        return currency + res
    }
}
