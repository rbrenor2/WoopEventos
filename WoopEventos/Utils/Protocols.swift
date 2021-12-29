//
//  Protocols.swift
//  WoopEventos
//
//  Created by Breno Ramos on 28/12/21.
//

import Foundation
import RxSwift

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    var input: Input { get }
    var output: Output { get }
}

protocol EventServiceType {
    func getEventList() -> Observable<[Event]>
    func getEvent(byId id: String) -> Observable<Event>
    func checkinEvent(byEventCheckin checkin: EventCheckin) -> Observable<EventCheckinResponse>
}
