//
//  LoginModel.swift
//  FutureLove
//
//  Created by TTH on 26/07/2023.
//

import Foundation

struct LoginModel : Codable {
    let count_comment : Int?
    let count_sukien : Int?
    let device_register : String?
    let email : String?
    let id_user : Int?
    let ip_register : String?
    let link_avatar : String?
    let user_name : String?
    let ketqua: String?
}


struct ResetPasswordModel : Codable {
    let message : String?
}
