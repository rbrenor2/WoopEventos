//
//  EventDetailViewController.swift
//  WoopEventos
//
//  Created by Breno Ramos on 24/12/21.
//

import Foundation
import RxSwift
import RxCocoa
import KeychainAccess

class EventDetailViewModel: ViewModelType {
    // MARK: - Properties
    
    let input: Input
    let output: Output
    
    private let eventService: EventServiceType
    private let disposeBag = DisposeBag()
    
    struct Input {
        let load: PublishRelay<Void>
        let checkin: PublishRelay<Void>
    }
        
    struct Output {
        let event: Driver<Event>
        let checkin: Driver<EventCheckinResponse>
        let loading: Driver<Bool>
        let error: Driver<String>
    }
        
    // MARK: - Lifecycle
    
    init(eventService: EventServiceType, keychainService: Keychain, eventId: String) {
        self.eventService = eventService
        
        let errorRelay = PublishRelay<String>()
        let loadingRelay = PublishRelay<Bool>()
        let loadRelay = PublishRelay<Void>()
        let checkinRelay = PublishRelay<Void>()

        let event = loadRelay
            .asObservable()
            .flatMap({ _ -> Observable<Event> in
                loadingRelay.accept(true)
                return eventService.getEvent(byId: eventId)
            })
            .map({ event in
                loadingRelay.accept(false)
                return event
            })
            .asDriver { (error) -> Driver<Event> in
                loadingRelay.accept(false)
                errorRelay.accept(error.localizedDescription)
                return Driver.just(Event())
        }
        
        let checkin = checkinRelay
            .asObservable()
            .flatMap({ _ -> Observable<EventCheckinResponse> in
                loadingRelay.accept(true)
                let username = keychainService["username"]!
                let email = keychainService["email"]!
                let checkin = EventCheckin(eventId: eventId, name: username, email: email)
                return eventService.checkinEvent(byEventCheckin: checkin)
            })
            .map({ checkin in
                loadingRelay.accept(false)
                return checkin
            })
            .asDriver { (error) -> Driver<EventCheckinResponse> in
                loadingRelay.accept(false)
                errorRelay.accept(error.localizedDescription)
                return Driver.just(EventCheckinResponse(status: "500"))
        }
        
        self.input = Input(load: loadRelay, checkin: checkinRelay)
        self.output = Output(event: event, checkin: checkin, loading: loadingRelay.asDriver(onErrorJustReturn: false), error: errorRelay.asDriver(onErrorJustReturn: K.EventList.reloadError))
    }
}
