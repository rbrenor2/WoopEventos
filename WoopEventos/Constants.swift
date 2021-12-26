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
        static let favoriteUnselectedIcon = "heart"
        static let favoriteSelectedIcon = "heart.fill"
    }
    
    struct EventDetail {
        static let descriptionTitle = "Descrição"
        static let locationTile = "Onde vai ser?"
        static let shareButtonIconName = "square.and.arrow.up"
        static let checkinButtonTitle = "Check-in"
        static let checkinAlertMessage = "Seu lugar já está reservado. Aproveite o evento!"
        static let checkinAlertTitle = "Status "
        static let checkinAlertActionButtonTitle = "OK"
    }
    
    struct Services {
        static let getEventListURL = "https://5f5a8f24d44d640016169133.mockapi.io/api/events"
        static let getEventURL = "https://5f5a8f24d44d640016169133.mockapi.io/api/events/{id}"
        static let postEventCheckinURL = "https://5f5a8f24d44d640016169133.mockapi.io/api/checkin"
    }
}
