//
//  EventService.swift
//  WoopEventos
//
//  Created by Breno Ramos on 21/12/21.
//

import Foundation
import RxSwift
import Alamofire

enum EventFailureReason: Int, Error {
    case unauthorized = 401
    case notFound = 404
    case badRequest = 400
}

struct EventCheckinResponse: Decodable {
    let code: String
}

struct EventService {
    static let shared = EventService()
    
    func getEventList() -> Observable<[Event]> {
        return Observable.create { observer -> Disposable in
            AF.request(K.Services.getEventListURL, method: .get)
                .validate()
                .responseDecodable(of: [Event].self) {
                    response in
        
                    switch response.result {
                    case .success:
                        do {
                            guard let data = response.data else {return}
                            let events = try JSONDecoder().decode([Event].self, from: data)
                            print("DEBUG: Events count \(events.count)")
                            observer.onNext(events)
                        } catch {
                            observer.onError(error)
                        }
                    case .failure(let error):
                        if let statusCode = response.response?.statusCode,
                            let reason = EventFailureReason(rawValue: statusCode)
                        {
                            observer.onError(reason)
                        }
                        observer.onError(error)
                    }
            
                }
                    
                return Disposables.create()
            }
    }
    
    func getEvent(byId id: String) -> Observable<Event> {
        return Observable.create { observer -> Disposable in
            
            let urlWithParameters = K.Services.getEventURL.replacingOccurrences(of: "{id}", with: id)
            
            AF.request(urlWithParameters, method: .get)
                .validate()
                .responseDecodable(of: Event.self) {
                    response in
        
                    switch response.result {
                    case .success:
                        do {
                            guard let data = response.data else {return}
                            let events = try JSONDecoder().decode(Event.self, from: data)
                            observer.onNext(events)
                        } catch {
                            observer.onError(error)
                        }
                    case .failure(let error):
                        if let statusCode = response.response?.statusCode,
                            let reason = EventFailureReason(rawValue: statusCode)
                        {
                            observer.onError(reason)
                        }
                        observer.onError(error)
                    }
            
                }
                    
                return Disposables.create()
            }
    }
    
    func checkinEvent(byEventCheckin checkin: EventCheckin) -> Observable<EventCheckinResponse> {
        return Observable.create { observer -> Disposable in
            AF.request(K.Services.postEventCheckinURL, method: .post, parameters: checkin)
                .validate()
                .responseDecodable(of: EventCheckinResponse.self) {
                    response in
        
                    switch response.result {
                    case .success:
                        do {
                            guard let data = response.data else {return}
                            let response = try JSONDecoder().decode(EventCheckinResponse.self, from: data)
                            observer.onNext(response)
                        } catch {
                            observer.onError(error)
                        }
                    case .failure(let error):
                        if let statusCode = response.response?.statusCode,
                            let reason = EventFailureReason(rawValue: statusCode)
                        {
                            observer.onError(reason)
                        }
                        observer.onError(error)
                    }
            
                }
                    
                return Disposables.create()
            }
    }
}
