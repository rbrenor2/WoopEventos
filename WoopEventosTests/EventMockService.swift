//
//  EventMockService.swift
//  WoopEventosTests
//
//  Created by Breno Ramos on 27/12/21.
//

import RxSwift
@testable import WoopEventos

let mockEvent = Event(people: ["Breno", "Paulo", "José"], date: 1534784400000, description: "This is a description", image: "www.google.com", longitude: 0.00, latitude: 0.00, price: 29.90, title: "Title", id: "1")

let mockEventCell = EventCellViewModelType.normal(event: mockEvent)

let mockEventCellList = [mockEventCell, mockEventCell, mockEventCell]

let mockEventList = [mockEvent, mockEvent, mockEvent]

class EventMockService: EventServiceType {

    func getEventList() -> Observable<[WoopEventos.Event]> {
        return Observable.of(mockEventList)
    }
    
    func getEvent(byId id: String) -> Observable<WoopEventos.Event> {
        return Observable.of(mockEvent)
    }
    
    func checkinEvent(byEventCheckin checkin: WoopEventos.EventCheckin) -> Observable<EventCheckinResponse> {
        let checkinResponse = EventCheckinResponse(code: "200")
        return Observable.of(checkinResponse)
    }
    
    
}
