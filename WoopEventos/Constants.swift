//
//  Constants.swift
//  WoopEventos
//
//  Created by Breno Ramos on 21/12/21.
//

import Foundation

struct K {
    struct General {
        static let woopLogoImage = "woopLogo"
    }
    
    struct EventList {
        
    }
    
    struct EventDetail {
        static let descriptionTitle = "Descrição"
        static let locationTile = "Onde vai ser?"
        static let shareButtonIconName = ""
        static let checkinButtonTitle = "Check-in"
    }
    
    struct Services {
        static let getEventListURL = "https://5f5a8f24d44d640016169133.mockapi.io/api/events"
        static let getEventURL = "https://5f5a8f24d44d640016169133.mockapi.io/api/events/{id}"
        static let postEventCheckinURL = "https://5f5a8f24d44d640016169133.mockapi.io/api/checkin"
    }
}
