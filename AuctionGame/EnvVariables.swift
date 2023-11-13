//
//  EnvVariables.swift
//  AuctionGame
//
//  Created by developer on 04.11.2023.
//

import Foundation
import UIKit
import CoreTelephony
import SystemConfiguration.CaptiveNetwork

var appProperties = AppProperties()
var auctionController = AuctionController()

var feedbackInfo: String {
    get {
        var data: String = "--- Don't Edit Anything Below ---\n"
        data += "Language: "
        data += (NSLocale.current.languageCode ?? "en") + "-"
        data += (NSLocale.current.regionCode ?? "US") + "\n"
        
        if #available(iOS 12.0, *) {
            if let providers = CTTelephonyNetworkInfo().serviceSubscriberCellularProviders {
                var buf: String = "Carrier: "
                var buf2: String = "Mobile Country Code: "
                providers.forEach { (key, value) in
                    buf += (value.carrierName ?? "NONE") + " "
                    buf2 += (value.mobileCountryCode ?? "NONE") + " "
                }
                data += buf + "\n" + buf2 + "\n"
            }
        } else {
            let provider = CTTelephonyNetworkInfo().subscriberCellularProvider
            data += "Carrier: " + (provider?.carrierName ?? "NONE") + "\n"
            data += "Mobile Country Code: " + (provider?.mobileCountryCode ?? "NONE") + "\n"
        }
        var buffer = "NetworkType: Cell\n"
        if let interfaces = CNCopySupportedInterfaces() as NSArray? {
            for interface in interfaces {
                if let interfaceInfo = CNCopyCurrentNetworkInfo(interface as! CFString) as NSDictionary? {
                    let ssid = interfaceInfo[kCNNetworkInfoKeySSID as String] as? String ?? ""
                        if (ssid != "")
                        {
                            buffer = "NetworkType: WiFi\n"
                        }
                }
            }
        }
        data += buffer
        data += "Country ISO: "
        if #available(iOS 12.0, *) {
            if let providers = CTTelephonyNetworkInfo().serviceSubscriberCellularProviders {
                    providers.forEach { (key, value) in
                        data += (value.isoCountryCode ?? "NONE") + " "
                    }
                data += "\n"
                }
            } else {
                let provider = CTTelephonyNetworkInfo().subscriberCellularProvider
                data += (provider?.isoCountryCode ?? "NONE") + "\n"
        }
        data += "Device: " + UIDevice.current.model + "\n"
        data += "Device ID: " + (UIDevice.current.identifierForVendor?.uuidString ?? "UNKNOWN") + "\n"
        data += "OS: iOS/" + UIDevice.current.systemVersion + "\n"
        data += "Username: " + UIDevice.current.name + "\n"
        data += "Version: " + (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "UNKNOWN VERSION")
        data += " (" + (Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "UNKNOWN BUILD NUMBER") + ")"
        return data
    }
}
