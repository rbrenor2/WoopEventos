//
//  KeychainService.swift
//  WoopEventos
//
//  Created by Breno Ramos on 29/12/21.
//


import Foundation
import KeychainAccess

class KeychainService: KeychainServiceType {    
    static var shared: Keychain? = Keychain(service: K.Services.keychainService)
}
