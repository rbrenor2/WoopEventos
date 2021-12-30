//
//  EventService.swift
//  WoopEventos
//
//  Created by Breno Ramos on 21/12/21.
//

import Foundation
import RxSwift
import Alamofire
import KeychainAccess

struct EventDetailResponse: Decodable, Equatable, Error {
    let status: Int
    var title: String?
    var message: String?
    
    static func == (lhs: EventDetailResponse, rhs: EventDetailResponse) -> Bool {
        return lhs.status == rhs.status
    }
}

class EventService: EventServiceType {
    // MARK: - Get Event list
    let shared = EventService()
        
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
                            
                            observer.onNext(events)
                            break
                        } catch {
                            observer.onError(error)
                            break
                        }
                    case .failure(let error):
                        if let statusCode = response.response?.statusCode,
                            let reason = EventFailureReason(rawValue: statusCode)
                        {
                            observer.onError(reason)
                        }
                        observer.onError(error)
                        break
                    }
            
                }
                    
                return Disposables.create()
            }
    }
    
    // MARK: - Get Event
    
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
                            let event = try JSONDecoder().decode(Event.self, from: data)
                            observer.onNext(event)
                            break
                        } catch {
                            observer.onError(error)
                            break
                        }
                    case .failure(let error):
                        if let statusCode = response.response?.statusCode,
                            let reason = EventFailureReason(rawValue: statusCode)
                        {
                            observer.onError(reason)
                        }
                        observer.onError(error)
                        break
                    }
            
                }
                    
                return Disposables.create()
            }
    }
    
    // MARK: - Checkin Event
    
    func checkinEvent(byId eventId: String) -> Observable<EventDetailResponse> {
        let keychain = Keychain(service: K.Services.keychainService)
        let username = keychain["username"]!
        let email = keychain["email"]!
        let checkin = EventCheckin(eventId: eventId, name: username, email: email)
        
        return Observable.create { observer -> Disposable in
            AF.request(K.Services.postEventCheckinURL, method: .post, parameters: checkin)
                .responseData {
                    response in

                    let statusCode = response.response!.statusCode
                    switch statusCode {
                    case 201:
                        var response = try! JSONDecoder().decode(EventDetailResponse.self, from: response.data!)
                        response.title = K.EventDetail.checkinSuccessTitle
                        response.message = K.EventDetail.checkinSuccessMessage
                        observer.onNext(response)
                        break
                    default:
                        let title = K.EventDetail.checkinErrorTitle
                        let message = try! JSONDecoder().decode(String.self, from: response.data!)
                        let error = EventDetailResponse(status: statusCode, title: title, message: message)
                        observer.onNext(error)
                    }
                }

                return Disposables.create()
            }
    }
}
