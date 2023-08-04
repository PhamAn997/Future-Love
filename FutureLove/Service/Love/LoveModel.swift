//
//  LoveModel.swift
//  FutureLove
//
//  Created by TTH on 25/07/2023.
//

import Foundation

struct LoveModel : Codable {
    let sukien : [DataGenEvent]?
    
}

struct DataGenEvent : Codable {
    let link_img : String?
    let id_template : Int?
    let id_user : String?
    let id_toan_bo_su_kien: Int?
    let imagecouple : String?
    let imagehusband : String?
    let imagewife : String?
    let phantram_loading : Int?
    let so_thu_tu_su_kien : Int?
    let tensukien : String?
    let thoigian : String?
    let thongtin : String?
    let tomluoc : String?
    let vtrinam : String?

    enum CodingKeys: String, CodingKey {

        case link_img = "Link_img"
        case id_template = "id_template"
        case id_user = "id_user"
        case id_toan_bo_su_kien = "id_toan_bo_su_kien"
        case imagecouple = "image couple"
        case imagehusband = "image husband"
        case imagewife = "image wife"
        case phantram_loading = "phantram_loading"
        case so_thu_tu_su_kien = "so_thu_tu_su_kien"
        case tensukien = "tensukien"
        case thoigian = "thoi gian"
        case thongtin = "thongtin"
        case tomluoc = "tom luoc"
        case vtrinam = "vtrinam"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        link_img = try values.decodeIfPresent(String.self, forKey: .link_img)
        id_template = try values.decodeIfPresent(Int.self, forKey: .id_template)
        id_toan_bo_su_kien = try values.decodeIfPresent(Int.self, forKey: .id_toan_bo_su_kien)
        id_user = try values.decodeIfPresent(String.self, forKey: .id_user)
        imagecouple = try values.decodeIfPresent(String.self, forKey: .imagecouple)
        imagehusband = try values.decodeIfPresent(String.self, forKey: .imagehusband)
        imagewife = try values.decodeIfPresent(String.self, forKey: .imagewife)
        phantram_loading = try values.decodeIfPresent(Int.self, forKey: .phantram_loading)
        so_thu_tu_su_kien = try values.decodeIfPresent(Int.self, forKey: .so_thu_tu_su_kien)
        tensukien = try values.decodeIfPresent(String.self, forKey: .tensukien)
        thoigian = try values.decodeIfPresent(String.self, forKey: .thoigian)
        thongtin = try values.decodeIfPresent(String.self, forKey: .thongtin)
        tomluoc = try values.decodeIfPresent(String.self, forKey: .tomluoc)
        vtrinam = try values.decodeIfPresent(String.self, forKey: .vtrinam)
    }
}



