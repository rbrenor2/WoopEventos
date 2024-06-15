//
//  Protocols.swift
//  WoopEventos
//
//  Created by Breno Ramos on 28/12/21.
//

import Foundation
import RxSwift
import KeychainAccess

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    var input: Input { get }
    var output: Output { get }
}

protocol EventServiceType {
    static var shared: EventService { get set }
    func getEventList() -> Observable<[Event]>
    func getEvent(byId id: String) -> Observable<Event>
    func checkinEvent(byId eventId: String) -> Observable<EventDetailResponse>
}

protocol KeychainServiceType {
    static var shared: Keychain { get set }
}

enum ErrorResult: Error {
    case custom(string: String)
    
    var localizedDescription: String {
        switch self {
        case .custom(let value):    return value
        }
    }
}

struct Response: Decodable { }

enum StatusCodeType: Int {
    case unauthorized = 401
    case notFound = 404
    case badRequest = 400
    case success = 201
}

enum EventFailureReason: Int, Error {
    case unauthorized = 401
    case notFound = 404
    case badRequest = 400
    case success = 201
}
