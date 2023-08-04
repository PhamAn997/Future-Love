
import Foundation

struct CommentsModel : Codable {
    let comment : [DataComment]
    let sophantu : Int?
    let sotrang : Double?
}

struct DataComment : Codable {
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
    let so_thu_tu_su_kien : Int?
}
