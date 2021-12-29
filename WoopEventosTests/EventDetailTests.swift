//
//  EventDetailTests.swift
//  WoopEventosTests
//
//  Created by Breno Ramos on 29/12/21.
//

import Foundation
import XCTest
import RxTest
import RxSwift
import RxCocoa
import KeychainAccess

@testable import WoopEventos

class EventDetailTests: XCTestCase {

    var viewModel : EventDetailViewModel!
    
    var scheduler: TestScheduler!
    var disposeBag: DisposeBag!
    fileprivate var service : MockEventService!
    fileprivate var eventId: String!
    
    override func setUp() {
        self.scheduler = TestScheduler(initialClock: 0)
        self.disposeBag = DisposeBag()
        self.service = MockEventService()
        self.eventId = "1"
        self.viewModel = EventDetailViewModel(eventService: service, eventId: eventId)
    }
    
    override func tearDown() {
        self.viewModel = nil
        self.service = nil
        super.tearDown()
    }
    
    func testGetEvent_error() {
        let event = scheduler.createObserver(WoopEventos.Event.self)
        let error = scheduler.createObserver(String.self)
        
        service.event = nil
        
        self.viewModel
            .output
            .event
            .drive(event)
            .disposed(by: disposeBag)
                
        self.viewModel
            .output
            .error
            .drive(error)
            .disposed(by: disposeBag)

        scheduler.createColdObservable([.next(10, ())])
            .bind(to: viewModel.input.load)
            .disposed(by: disposeBag)
        
        scheduler.start()

        XCTAssertEqual(error.events, [.next(10, "Error: get event detail")])
    }
    
    func testGetEvent_success() {
        let event = scheduler.createObserver(WoopEventos.Event.self)
        
        let expected: WoopEventos.Event = DataGenerator.mockEvent(byId: eventId)
        service.event = DataGenerator.mockEvent(byId: eventId)
        
        self.viewModel
            .output
            .event
            .drive(event)
            .disposed(by: disposeBag)
                
        scheduler.createColdObservable([.next(10, ())])
            .bind(to: viewModel.input.load)
            .disposed(by: disposeBag)
        
        scheduler.start()

        XCTAssertEqual(event.events, [.next(10, expected)])
    }
    
    func testCheckin_success() {
        let checkin = scheduler.createObserver(WoopEventos.EventDetailResponse.self)
        
        let expected: WoopEventos.EventDetailResponse = DataGenerator.mockCheckinResponse()
        
        self.viewModel
            .output
            .checkin
            .drive(checkin)
            .disposed(by: disposeBag)
                
        scheduler.createColdObservable([.next(10, ())])
            .bind(to: viewModel.input.checkin)
            .disposed(by: disposeBag)
        
        scheduler.start()

        XCTAssertEqual(checkin.events, [.next(10, expected), .completed(10)])
    }
    
    func testCheckin_error() {
        let checkin = scheduler.createObserver(WoopEventos.EventDetailResponse.self)
        let error = scheduler.createObserver(String.self)
        
        service.checkinResponse = nil
        
        self.viewModel
            .output
            .checkin
            .drive(checkin)
            .disposed(by: disposeBag)
                
        self.viewModel
            .output
            .error
            .drive(error)
            .disposed(by: disposeBag)

        scheduler.createColdObservable([.next(10, ())])
            .bind(to: viewModel.input.checkin)
            .disposed(by: disposeBag)
        
        scheduler.start()

        XCTAssertEqual(error.events, [.next(10, "Error: checkin")])
    }
}
