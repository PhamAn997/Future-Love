//
//  Template3TBVCell.swift
//  FutureLove
//
//  Created by TTH on 02/08/2023.
//

import UIKit

class Template3TBVCell: UITableViewCell {

    @IBOutlet weak var CountView: UIButton!
    @IBOutlet weak var countComment: UIButton!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func configCell(model: Sukien) {
//        if let url = URL(string: model.link_da_swap.asStringOrEmpty()){
//            titleImage.af.setImage(withURL: url)
//        }
        descriptionLabel.text = model.noi_dung_su_kien
        nameLabel.text = model.ten_su_kien
     
        let time = self.getFormattedDate(strDate: model.real_time.asStringOrEmpty() ,
                                         currentFomat: "yyyy-MM-dd, HH:mm:ss",
                                         expectedFromat: "yyyy-MM-dd")
        dateLabel.text = time
        countComment.setTitle(model.count_comment?.toString(), for: .normal)
        CountView.setTitle(model.count_view?.toString(), for: .normal)

    }
    func configCellDetail(model: EventModel) {
//        if let url = URL(string: model.link_da_swap.asStringOrEmpty()){
//            avatarImage.af.setImage(withURL: url)
//        }
        descriptionLabel.text = model.noi_dung_su_kien
        nameLabel.text = model.ten_su_kien
     
        let time = self.getFormattedDate(strDate: model.real_time.asStringOrEmpty() ,
                                         currentFomat: "yyyy-MM-dd, HH:mm:ss",
                                         expectedFromat: "yyyy-MM-dd")
        dateLabel.text = time
        countComment.setTitle(model.count_comment?.toString(), for: .normal)
        CountView.setTitle(model.count_view?.toString(), for: .normal)

    }
    
    func getFormattedDate(strDate: String , currentFomat: String, expectedFromat: String) -> String {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = currentFomat

        let date : Date = dateFormatterGet.date(from: strDate) ?? Date()

        dateFormatterGet.dateFormat = expectedFromat
        return dateFormatterGet.string(from: date)
    }
}
