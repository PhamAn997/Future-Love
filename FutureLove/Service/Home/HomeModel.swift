
import Foundation


struct HomeModel : Codable {
    let list_sukien : [List_sukien]?
}

struct List_sukien : Codable {
    let sukien : [Sukien]?
}
struct Sukien: Codable {
    let count_comment : Int?
    let count_view : Int?
    let id : Int?
    let id_toan_bo_su_kien : Int?
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


struct UploadImage : Codable {
    let data : DataLove?
}

struct DataLove : Codable {
    let url : String?
}

