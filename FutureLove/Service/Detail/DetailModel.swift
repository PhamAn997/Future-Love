//
//  DetailModel.swift
//  FutureLove
//
//  Created by TTH on 26/07/2023.
//

import Foundation

struct CommentEvent : Codable {
    let comment : [DataCommentEvent]?
}
struct DataCommentEvent : Codable {
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
    let location: String?
}

struct DetailEvent: Codable {
    let sukien : [EventModel]?
}

struct EventModel: Codable {
    let count_comment : Int?
    let count_view : Int?
    let id : Int?
    let id_user : Int?
    let id_template: Int?
    let link_da_swap : String?
    let link_nam_chua_swap : String?
    let link_nam_goc : String?
    let link_nu_chua_swap : String?
    let link_nu_goc : String?
    let noi_dung_su_kien : String?
    let phantram_loading : Int?
    let real_time : String?
    let so_thu_tu_su_kien : Int?
    let ten_nam : String?
    let ten_nu : String?
    let ten_su_kien : String?
}

struct PostComments: Codable {
    let comment : Comment
}

struct Comment: Codable {
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
    let thoi_gian_release : String?
    let user_name : String?
    let location: String?
}
