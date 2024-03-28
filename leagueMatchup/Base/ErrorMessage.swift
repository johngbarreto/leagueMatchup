//
//  ErrorMessage.swift
//  leagueMatchup
//
//  Created by João Gabriel Lavareda Ayres Barreto on 01/02/24.
//

import Foundation

enum ErrorMessage: String, Error {
    case urlError = "url"
    case networkError = "network"
    case invalidResponse = "invalid resp"
    case invalidData = "invalid data"
    case decodingError = "decoding error"
    case championError = "Coundn't get champion"
}
