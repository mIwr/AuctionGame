//
//  AppProperties.swift
//  AuctionGame
//
//  Created by Developer on 09.09.2020.


import Foundation

class AppProperties: Codable
{
    fileprivate static let DefaultPropertiesFilename = "shared_props"
    
    var topScore: UInt64
    var usedLots: [String]
    
    init() {
        topScore = 0
        usedLots = []
    }
    
    init(best: UInt64, used: [String])
    {
        topScore = best
        usedLots = used
    }
    
    static func load() -> AppProperties
    {
        return PlistWrapper.parsePropertyList(filename: DefaultPropertiesFilename) ?? AppProperties()
    }
    
    func save()
    {
        if !PlistWrapper.savePropertyList(self, filename: AppProperties.DefaultPropertiesFilename)
        {
            #if DEBUG
                print("Application properties not saved")
            #endif
        }
    }
}
