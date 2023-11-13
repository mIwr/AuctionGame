//
//  AuctionLot.swift
//  AuctionGame
//
//  Created by Developer on 07.09.2020.
//

import Foundation

class Lot: Codable, Equatable, Hashable
{
    let id: String
    let title: String
    let medium: String
    let artist: String
    let date: String
    let price: UInt64
    var formattedPrice: String {
        get {
            return PriceUtil.getFormattedPrice(price)
        }
    }
    let img: String
    var imgFilename: String { get {return img + ".jpg"} }
    
    init(id: String, title: String, medium: String, artist: String, date: String, price: UInt64, imgID: String) {
        self.id = id
        self.title = title
        self.medium = medium
        self.artist = artist
        self.date = date
        self.price = price
        self.img = imgID
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Lot, rhs: Lot) -> Bool {
        return lhs.id == rhs.id && lhs.title == rhs.title && lhs.artist == rhs.artist && lhs.price == rhs.price && lhs.price == rhs.price
    }
    
    //{"id":"qpe932d","index":332,"title":"Car Hood","medium":"Sprayed acrylic on Corvair car hood; sold with custom display box","artist":"Designed by Judy Chicago","date":"1964","img":"z5vva2y73a8pqp6dfsy65"}
    
    static func from(dict: [String: Any]) -> Lot? {
        guard let id = dict[Lot.CodingKeys.id.stringValue] as? String else {return nil}
        guard let title = dict[Lot.CodingKeys.title.stringValue] as? String else {return nil}
        guard let medium = dict[Lot.CodingKeys.medium.stringValue] as? String else {return nil}
        guard let artist = dict[Lot.CodingKeys.artist.stringValue] as? String else {return nil}
        guard let date = dict[Lot.CodingKeys.date.stringValue] as? String else {return nil}
        guard let price = dict[Lot.CodingKeys.price.stringValue] as? UInt64 else {return nil}
        guard let imgID = dict[Lot.CodingKeys.img.stringValue] as? String else {return nil}
        return Lot(id: id, title: title, medium: medium, artist: artist, date: date, price: price, imgID: imgID)
    }
}
