//
//  WoopEventosTests.swift
//  WoopEventosTests
//
//  Created by Breno Ramos on 27/12/21.
//

import Foundation
import XCTest
import RxTest
import RxSwift
import RxCocoa

@testable import WoopEventos

class EventListTests: XCTestCase {
    var viewModel : EventListViewModel!
    
    var scheduler: TestScheduler!
    var disposeBag: DisposeBag!
    fileprivate var service : MockEventService!
    
    override func setUp() {
        self.scheduler = TestScheduler(initialClock: 0)
        self.disposeBag = DisposeBag()
        self.service = MockEventService()
        self.viewModel = EventListViewModel(eventService: service)
    }
    
    override func tearDown() {
        self.viewModel = nil
        self.service = nil
        super.tearDown()
    }
    
    func testGetEventList_error() {
        let events = scheduler.createObserver(Array<WoopEventos.Event>.self)
        let error = scheduler.createObserver(String.self)
        
        service.event = nil
        
        self.viewModel
            .output
            .events
            .drive(events)
            .disposed(by: disposeBag)
                
        self.viewModel
            .output
            .error
            .drive(error)
            .disposed(by: disposeBag)

        scheduler.createColdObservable([.next(10, ())])
            .bind(to: viewModel.input.reload)
            .disposed(by: disposeBag)
        
        scheduler.start()

        XCTAssertEqual(error.events, [.next(10, "Error: get event list")])
    }
    
    func testGetEventList_success() {
        let eventList = scheduler.createObserver(Array<WoopEventos.Event>.self)
        
        let expected: Array<WoopEventos.Event> = DataGenerator.mockEventList()
        service.eventList = DataGenerator.mockEventList()
        
        self.viewModel
            .output
            .events
            .drive(eventList)
            .disposed(by: disposeBag)
                
        scheduler.createColdObservable([.next(10, ()), .next(30, ())])
            .bind(to: viewModel.input.reload)
            .disposed(by: disposeBag)
        
        scheduler.start()

        XCTAssertEqual(eventList.events, [.next(10, expected), .next(30, expected)])
    }
}
