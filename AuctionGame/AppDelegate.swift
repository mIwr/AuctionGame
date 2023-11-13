//
//  AppDelegate.swift
//  AuctionGame
//
//  Created by Developer on 07.09.2020.


import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        appProperties = AppProperties.load()
        let lots = AppDelegate.loadLotsData()
        auctionController = AuctionController(usedLots: appProperties.usedLots, allLots: lots, topScore: appProperties.topScore)
        return true
    }

    func applicationDidBecomeActive(_ application: UIApplication) {

    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        if let g_window = application.windows.first
        {
            g_window.rootViewController?.view.endEditing(true)
        }
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {

    }
    
    fileprivate static func loadLotsData() -> [Lot] {
        let bundle = Bundle(for: Self.self)
        guard let safeUrl = bundle.url(forResource: "auction", withExtension: "json") else {return []}
        guard let safeData = (try? Data(contentsOf: safeUrl)) else {return []}
        do {
            guard let jsonObj = try JSONSerialization.jsonObject(with: safeData, options: []) as? [[String: Any]] else {
                #if DEBUG
                print("Unable parse JSON from data (" + String(safeData.count) + " bytes)")
                #endif
                return []
            }
            var lots: [Lot] = []
            for dict in jsonObj {
                guard let safeParsed = Lot.from(dict: dict) else {
                    #if DEBUG
                    print("Parse lot fail", dict)
                    #endif
                    continue
                }
                lots.append(safeParsed)
            }
            return lots
        } catch {
            #if DEBUG
            print("Read local lots error")
            print(error)
            #endif
        }
        return []
    }
}

