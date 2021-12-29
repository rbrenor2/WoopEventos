//
//  File.swift
//  WoopEventosTests
//
//  Created by Breno Ramos on 29/12/21.
//

import Foundation
import RxSwift

@testable import WoopEventos

class MockEventService: EventServiceType {
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
    
    func checkinEvent(byId eventId: String) -> Observable<EventCheckinResponse> {
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
