//
//  EventsTableViewViewModel.swift
//  WoopEventos
//
//  Created by Breno Ramos on 23/12/21.
//

import RxSwift
import RxCocoa

enum EventCellViewModelType {
    case normal(event: Event)
    case error(message: String)
    case empty
}

class EventListViewModel {
    // MARK: - Properties
    private let eventService: EventService
    
    private let loading = BehaviorRelay<Bool>(value: false)
    private let cells = BehaviorRelay<[EventCellViewModelType]>(value: [])
    private let disposeBag = DisposeBag()
    
    var eventLoading: Observable<Bool> {
        return loading.asObservable()
    }

    var eventCells: Observable<[EventCellViewModelType]> {
        return cells.asObservable()
    }
    
    let onShowError = PublishSubject<UIAlertController>()
    
    // MARK: - Lifecycle
    
    init(eventService: EventService) {
        self.eventService = eventService
    }
    
    // MARK: - API
    
    func getEvents() {
        loading.accept(true)
        
        eventService.getEventList().subscribe (onNext: { [unowned self] events in
            self.loading.accept(false)
            
            let count = events.count
            if count == 0 {
                self.cells.accept([.empty])
            }
            
            let cellsViewModelList: [EventCellViewModelType] = events.compactMap { event in
                
                let type = EventCellViewModelType.normal(event: event)
                return type
            }
            
            self.cells.accept(cellsViewModelList)
        }, onError: { [unowned self] error in
            self.loading.accept(false)
            self.cells.accept([.error(message: "Xiii, ocorreu um problema. Tente novamente em alguns momentos.")])
        }).disposed(by: disposeBag)
    }
}


