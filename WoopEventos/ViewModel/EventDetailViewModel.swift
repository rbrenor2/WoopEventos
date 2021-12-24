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

class EventDetailViewModel {
    private let loading = BehaviorRelay(value: false)
    private let detail = BehaviorRelay<EventDetailViewModelType>(value: .empty)
    private let disposeBag = DisposeBag()

    var eventDetail: Observable<EventDetailViewModelType> {
        return detail.asObservable()
    }
    
    let onShowError = PublishSubject<UIAlertController>()
            
    func getEvent(id: String) {
        loading.accept(true)
        
        EventService.shared.getEvent(byId: id).subscribe (onNext: { [weak self] event in
            self?.loading.accept(false)
            
            if event.date == nil {
                self?.detail.accept(.empty)
            }
            
            let viewModel = EventViewModel(event: event)
            let eventDetailViewModel: EventDetailViewModelType = EventDetailViewModelType.normal(eventViewModel: viewModel)
            
            self?.detail.accept(eventDetailViewModel)
        }, onError: { [weak self] error in
            self?.loading.accept(false)
            self?.detail.accept(.error(message: "Xiii, ocorreu um problema. Tente novamente em alguns momentos."))
        }).disposed(by: disposeBag)
    }
}
