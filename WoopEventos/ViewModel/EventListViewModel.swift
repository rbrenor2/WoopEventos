//
//  EventsTableViewViewModel.swift
//  WoopEventos
//
//  Created by Breno Ramos on 23/12/21.
//

import RxSwift
import RxCocoa

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    var input: Input { get }
    var output: Output { get }
}

class EventListViewModel {
    
    // MARK: - Properties
    
    let input: Input
    let output: Output
    
    private let eventService: EventServiceType
    private let disposeBag = DisposeBag()
    
    struct Input {
        let reload: PublishRelay<Void>
    }
        
    struct Output {
        let events: Driver<[Event]>
        let loading: Driver<Bool>
        let error: Driver<String>
    }
    
    // MARK: - Lifecycle
    
    init(eventService: EventServiceType) {
        self.eventService = eventService
        
        let errorRelay = PublishRelay<String>()
        let loadingRelay = PublishRelay<Bool>()
        let reloadRelay = PublishRelay<Void>()
    
        let events = reloadRelay
            .asObservable()
            .flatMap({ _ -> Observable<[Event]> in
                loadingRelay.accept(true)
                return eventService.getEventList()
            })
            .map({ events in
                loadingRelay.accept(false)
                return events
            })
            .asDriver { (error) -> Driver<[Event]> in
                loadingRelay.accept(false)
                errorRelay.accept(error.localizedDescription)
                return Driver.just([])
        }
        
        self.input = Input(reload: reloadRelay)
        self.output = Output(events: events, loading: loadingRelay.asDriver(onErrorJustReturn: false), error: errorRelay.asDriver(onErrorJustReturn: "GeneralError"))
    }
}


