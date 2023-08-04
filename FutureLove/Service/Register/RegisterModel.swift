//
//  RegisterModel.swift
//  FutureLove
//
//  Created by TTH on 26/07/2023.
//

import Foundation

struct RegisterModel: Codable {
    let account : data?
    let message: String?
}

struct data : Codable {
    let email: String
}

struct IPAddress: Codable {
    let ip: String
    let city: String
    let region: String
    let country: String
    let loc: String
    let org: String
    let postal: String
    let timezone: String
    let readme: String
}

