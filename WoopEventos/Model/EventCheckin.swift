//
//  EventCheckin.swift
//  WoopEventos
//
//  Created by Breno Ramos on 23/12/21.
//

import Foundation

struct EventCheckin: Encodable {
    let eventId: String
    let name: String
    let email: String
    
    init(eventId: String, name: String, email: String) {
        self.eventId = eventId
        self.name = name
        self.email = email
    }
}
