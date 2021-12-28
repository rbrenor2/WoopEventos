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
    
    private enum CodingKeys : String, CodingKey { case people, date, description, image, longitude, latitude, price, title, id }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        people = try values.decode([String].self, forKey: .people)
        description = try values.decode(String.self, forKey: .description)
        longitude = try values.decode(Double.self, forKey: .longitude)
        latitude = try values.decode(Double.self, forKey: .latitude)
        price = try values.decode(Double.self, forKey: .price)
        title = try values.decode(String.self, forKey: .title)
        id = try values.decode(String.self, forKey: .id)

        let unixDate = try values.decode(Double.self, forKey: .date)
        date = Date(timeIntervalSince1970: unixDate/1000)
        
        let imageUrl = try values.decode(String.self, forKey: .image)
        var comps = URLComponents(string: imageUrl)
        comps?.scheme = "https"
        guard let secureUrl = URL(string: comps!.string!) else {return}
        image = secureUrl
    }
    
    init(people: [String], date: Double, description: String, image: String, longitude: Double, latitude: Double, price: Double, title: String, id: String) {
        
        self.people = people
        self.description = description
        self.longitude = longitude
        self.latitude = latitude
        self.price = price
        self.title = title
        self.id = id
        self.image = URL(string: image)!
        self.date = Date(timeIntervalSince1970: date/1000)
    }
}
