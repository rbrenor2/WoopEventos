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
import RxBlocking

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
        
        service.eventList = nil
        
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

fileprivate class MockEventService: EventServiceType {
    var eventList : [WoopEventos.Event]?
    var event: WoopEventos.Event?
    var checkinResponse: WoopEventos.EventCheckinResponse?
    
    func getEventList() -> Observable<[WoopEventos.Event]> {
        if let events = eventList {
            return Observable.just(events)
        } else {
            return Observable.error(ErrorResult.custom(string:"Error: get event list"))
        }
    }
    
    func getEvent(byId id: String) -> Observable<WoopEventos.Event> {
        if let event = event {
            return Observable.just(event)
        } else {
            return Observable.error(ErrorResult.custom(string:"Error: get event detail"))
        }
    }
    
    func checkinEvent(byEventCheckin checkin: EventCheckin) -> Observable<EventCheckinResponse> {
        if let response = checkinResponse {
            return Observable.just(response)
        } else {
            return Observable.error(ErrorResult.custom(string:"Error: checkin"))
        }
    }
}

class DataGenerator {
    static func mockEventList() -> [WoopEventos.Event] {
        let mockEvent1 = Event(people: ["Breno", "Paulo", "José"], date: 1534784400000, description: "This is a description", image: "www.google.com", longitude: 0.00, latitude: 0.00, price: 29.90, title: "Title", id: "1")
        
        let mockEvent2 = Event(people: ["Breno", "Paulo", "José"], date: 1534784400000, description: "This is a description", image: "www.google.com", longitude: 0.00, latitude: 0.00, price: 29.90, title: "Title", id: "2")
        
        let mockEvent3 = Event(people: ["Breno", "Paulo", "José"], date: 1534784400000, description: "This is a description", image: "www.google.com", longitude: 0.00, latitude: 0.00, price: 29.90, title: "Title", id: "3")
        
        return [mockEvent1, mockEvent2, mockEvent3]
    }
    
    static func mockEvent(byId id: String) -> WoopEventos.Event {
        let found = self.mockEventList().filter { event in
            return event.id == id
        }
        
        return found[0]
    }
    
    static func mockCheckinResponse() -> WoopEventos.EventCheckinResponse {
        let response = EventCheckinResponse(status: "200")
        
        return response
    }
}
