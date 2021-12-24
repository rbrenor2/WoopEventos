//
//  Evento.swift
//  WoopEventos
//
//  Created by Breno Ramos on 21/12/21.
//

import Foundation

struct Event: Decodable {
    let people: [String]
    var date: Date!
    let description: String
    var image: URL?
    let longitude: Double
    let latitude: Double
    let price: Double
    let title: String
    let id: String
    
    init(dictionary: [String: Any]) {
        people = dictionary["people"] as? [String] ?? []
        description = dictionary["description"] as? String ?? ""
        longitude = dictionary["longitude"] as? Double ?? 0.00
        latitude = dictionary["latitude"] as? Double ?? 0.00
        price = dictionary["price"] as? Double ?? 0.00
        title = dictionary["title"] as? String ?? ""
        id = dictionary["id"] as? String ?? ""

        if let timestamp = dictionary["date"] as? Double {
            date = Date(timeIntervalSince1970: timestamp)
        }
        
        if let imageUrl = dictionary["image"] as? String {
            guard let url = URL(string: imageUrl) else {return}
            image = url
        }
    }
}
