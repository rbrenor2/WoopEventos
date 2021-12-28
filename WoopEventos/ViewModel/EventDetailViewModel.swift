//
//  EventDetailViewController.swift
//  WoopEventos
//
//  Created by Breno Ramos on 24/12/21.
//

import Foundation
import RxSwift
import RxCocoa

enum EventDetailViewModelType {
    case normal(event: Event)
    case error(message: String)
    case empty
}

enum EventChekinViewModelType {
    case normal(code: String)
    case error(message: String)
    case empty
}

class EventDetailViewModel {
    // MARK: - Properties
    
    private let eventService: EventServiceType

    private let loading = BehaviorRelay<Bool>(value: false)
    private let detail = BehaviorRelay<EventDetailViewModelType>(value: .empty)
    private let checkin = BehaviorRelay<EventChekinViewModelType>(value: .empty)
    private let disposeBag = DisposeBag()
    
    var eventLoading: Observable<Bool> {
        return loading.asObservable()
    }

    var eventCheckin: Observable<EventChekinViewModelType> {
        return checkin.asObservable()
    }
    var eventDetail: Observable<EventDetailViewModelType> {
        return detail.asObservable()
    }
    
    let onShowError = PublishSubject<UIAlertController>()
    
    // MARK: - Lifecycle
    
    init(eventService: EventServiceType) {
        self.eventService = eventService
    }
    
    // MARK: - API
            
    func getEvent(id: String) {
        loading.accept(true)
        
        eventService.getEvent(byId: id).subscribe (onNext: { [unowned self] event in
            self.loading.accept(false)
            
            if event.id == "" {
                self.detail.accept(.empty)
            }
            
            let eventDetailViewModel: EventDetailViewModelType = EventDetailViewModelType.normal(event: event)
            
            self.detail.accept(eventDetailViewModel)
        }, onError: { [unowned self] error in
            self.loading.accept(false)
            self.detail.accept(.error(message: "Xiii... ocorreu um problema"))
        }).disposed(by: disposeBag)
    }
    
    func checkinEvent(eventCheckin: EventCheckin) {
        loading.accept(true)
        
        eventService.checkinEvent(byEventCheckin: eventCheckin).subscribe (onNext: { [unowned self] response in
            self.loading.accept(false)
            
            let eventCheckinViewModel: EventChekinViewModelType = EventChekinViewModelType.normal(code: response.code)
            
            self.checkin.accept(eventCheckinViewModel)
        }, onError: { [unowned self] error in
            self.loading.accept(false)
            self.checkin.accept(.error(message: K.EventDetail.checkinErrorMessage.replacingOccurrences(of: "{code}", with: "\(error)")))
        }).disposed(by: disposeBag)
    }
}
