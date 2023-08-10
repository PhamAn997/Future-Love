//
//  ProfileModel.swift
//  FutureLove
//
//  Created by TTH on 30/07/2023.
//

import Foundation

struct RecentCommentModel : Codable {
    let comment_user : [CommentUser]?
}

struct CommentUser : Codable {
    let avatar_user : String?
    let device_cmt : String?
    let dia_chi_ip : String?
    let id_comment : Int?
    let id_toan_bo_su_kien : Int?
    let id_user : Int?
    let imageattach : String?
    let link_nam_goc : String?
    let link_nu_goc : String?
    let noi_dung_cmt : String?
    let so_thu_tu_su_kien : Int?
    let thoi_gian_release : String?
    let user_name : String?
}

struct ProfileModel: Codable {
    let count_comment: Int?
    let count_sukien: Int?
    let count_view : Int?
    let device_register: String?
    let email: String?
    let id_user: Int?
    let ip_register: String?
    let link_avatar: String?
    let user_name: String?
}
