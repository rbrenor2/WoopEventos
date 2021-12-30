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
        static let placeholderimage = "placeholder"
        static let confirmAlertButtonTitle = "OK"
        static let checkinErrorDefaultMessage = "Tente novamente em alguns instantes"
    }
    
    struct EventList {
        static let favoriteUnselectedIcon = "heart"
        static let favoriteSelectedIcon = "heart.fill"
        static let refreshTitle = "Carregando..."
        static let reloadErrorTitle = "Xiii... ocorreu algum erro"
        static let reloadError = "Xiii... ocorreu algum erro. Tente novemente em alguns momentos."
        static let emptyTableMessage = "Nenhum evento no momento"
    }
    
    struct EventDetail {
        static let descriptionTitle = "Descrição"
        static let locationTitle = "Onde vai ser?"
        static let shareButtonIconName = "square.and.arrow.up.fill"
        static let checkinButtonTitle = "Check-in"
        static let checkinConfirmedButtonTitle = "Confirmado"
        static let checkinAlertActionButtonTitle = "OK"
        static let checkinErrorTitle = "Xiii... ocorreu algum problema."
        static let checkinErrorMessage = "Status: {code}"
        static let checkinSuccessTitle = "Parabéns!"
        static let checkinSuccessMessage = "Seu lugar já está reservado.\nAproveite o evento!"
        static let closeButtonIconName = "xmark.circle.fill"
        static let uncheckMessage = "Caso mude de ideia, é só fazer o check-in novamente"
        static let uncheckTitle = "Reserva cancelada"
    }
    
    struct EventError {
        static let closeButtonTitle = "Fechar"
    }
    
    struct Services {
        static let getEventListURL = "https://5f5a8f24d44d640016169133.mockapi.io/api/events"
        static let getEventURL = "https://5f5a8f24d44d640016169133.mockapi.io/api/events/{id}"
        static let postEventCheckinURL = "https://5f5a8f24d44d640016169133.mockapi.io/api/checkin"
        static let keychainService = "com.woopeventos-credentials"
    }
}
