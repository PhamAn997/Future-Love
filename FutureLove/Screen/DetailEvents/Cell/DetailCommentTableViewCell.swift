//
//  DetailCommentTableViewCell.swift
//  FutureLove
//
//  Created by TTH on 28/07/2023.
//

import UIKit
import AlamofireImage

class DetailCommentTableViewCell: UITableViewCell {
   
    @IBOutlet weak var imageAvatar: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    func configCell(model: DataCommentEvent) {
        if let url = URL(string: model.imageattach.asStringOrEmpty()) {
            imageAvatar.af.setImage(withURL: url)
        }
        userNameLabel.text = model.user_name
        descriptionLabel.text = model.noi_dung_cmt
        locationLabel.text = "IP: \(model.dia_chi_ip ?? "") - \(model.location ?? "")"
        
        let dateString = model.thoi_gian_release.asStringOrEmpty()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        guard let targetDate = dateFormatter.date(from: dateString) else {
            return
        }
        let currentDate = Date()
        let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: targetDate, to: currentDate)
        var result = ""
        if let years = components.year, years > 0 {
            result = "\(years) years ago"
        } else if let months = components.month, months > 0 {
            result = "\(months) months ago"
        } else if let days = components.day, days > 0 {
            result = "\(days) days ago"
        } else if let hours = components.hour, hours > 0 {
            result = "\(hours) hour ago"
        } else if let minutes = components.minute, minutes > 0 {
            result = "\(minutes) min ago"
        } else if let seconds = components.second, seconds > 0 {
            result = "\(seconds) sec ago"
        } else {
            result = "Vừa xong"
        }
        self.timeLabel.text = result
    }
    
    func configCellComment(model: DataComment) {
        if let url = URL(string: model.avatar_user.asStringOrEmpty()) {
            imageAvatar.af.setImage(withURL: url)
        }
        userNameLabel.text = model.user_name
        descriptionLabel.text = model.noi_dung_cmt
        locationLabel.text = "IP: \(model.dia_chi_ip ?? "") - \(model.location ?? "")"
        
        let dateString = model.thoi_gian_release.asStringOrEmpty()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        guard let targetDate = dateFormatter.date(from: dateString) else {
            return
        }
        let currentDate = Date()
        let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: targetDate, to: currentDate)
        var result = ""
        if let years = components.year, years > 0 {
            result = "\(years) years ago"
        } else if let months = components.month, months > 0 {
            result = "\(months) months ago"
        } else if let days = components.day, days > 0 {
            result = "\(days) days ago"
        } else if let hours = components.hour, hours > 0 {
            result = "\(hours) hour ago"
        } else if let minutes = components.minute, minutes > 0 {
            result = "\(minutes) min ago"
        } else if let seconds = components.second, seconds > 0 {
            result = "\(seconds) sec ago"
        } else {
            result = "Vừa xong"
        }
        self.timeLabel.text = result
      
    }
}
