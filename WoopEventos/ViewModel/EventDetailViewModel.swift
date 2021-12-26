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
    case normal(eventViewModel: EventViewModel)
    case error(message: String)
    case empty
}

enum EventChekinViewModelType {
    case normal(code: String)
    case error(message: String)
    case empty
}

class EventDetailViewModel {
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
            
    func getEvent(id: String) {
        loading.accept(true)
        
        EventService.shared.getEvent(byId: id).subscribe (onNext: { [unowned self] event in
            self.loading.accept(false)
            
            if event.date == nil {
                self.detail.accept(.empty)
            }
            
            let viewModel = EventViewModel(event: event)
            let eventDetailViewModel: EventDetailViewModelType = EventDetailViewModelType.normal(eventViewModel: viewModel)
            
            self.detail.accept(eventDetailViewModel)
        }, onError: { [unowned self] error in
            self.loading.accept(false)
            self.detail.accept(.error(message: "Xiii, ocorreu um problema. Tente novamente em alguns momentos."))
        }).disposed(by: disposeBag)
    }
    
    func checkinEvent(eventCheckin: EventCheckin) {
        loading.accept(true)
        
        EventService.shared.checkinEvent(byEventCheckin: eventCheckin).subscribe (onNext: { [unowned self] response in
            self.loading.accept(false)
            
            let eventCheckinViewModel: EventChekinViewModelType = EventChekinViewModelType.normal(code: response.code)
            
            self.checkin.accept(eventCheckinViewModel)
        }, onError: { [unowned self] error in
            self.loading.accept(false)
            self.detail.accept(.error(message: "Xiii, ocorreu um problema no Checkin. Tente novamente em alguns momentos."))
        }).disposed(by: disposeBag)
    }
}
