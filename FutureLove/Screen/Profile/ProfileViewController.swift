//
//  ProfileViewController.swift
//  Future Love
//
//

import UIKit
import AlamofireImage

class ProfileViewController: UIViewController {
    
    var dataRecentCommemt: [CommentUser] = []
    var dataUserEvent: [Sukien] = []
    @IBOutlet weak var recentCommentTableView: UITableView!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var noCommentLabel: UILabel!
    
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var countEventLabel: UILabel!
    @IBOutlet weak var countViewLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var countCommentLabel: UILabel!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        backgroundView.gradient()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        callAPIRecentComment()
        callApiProfile()
        callAPIUserEvent()
    }
    func setupUI() {
        self.navigationController?.isNavigationBarHidden = true
        recentCommentTableView.delegate = self
        recentCommentTableView.dataSource = self
        recentCommentTableView.register(cellType: DetailCommentTableViewCell.self)
      
    }
    func callApiProfile() {
        ProfileAPI.shared.getProfile(id_user: AppConstant.userId ?? 0) { result in
            switch result {
            case .success(let success):
                self.userNameLabel.text = success.user_name
                self.countEventLabel.text = success.count_sukien?.toString()
                self.countCommentLabel.text = success.count_comment?.toString()
                self.countViewLabel.text = (success.count_view ?? 0).toString()
                if let url = URL(string: success.link_avatar.asStringOrNilText()) {
                    self.avatarImage.af.setImage(withURL: url)
                }
            case .failure(let failure):
                print(failure)
            }
        }
    }
    
    func callAPIRecentComment() {
        ProfileAPI.shared.getRecentComment(id_user: AppConstant.userId ?? 0) { result in
            switch result {
            case .success(let success):
                self.dataRecentCommemt = success.comment_user?.reversed() ?? []
                self.recentCommentTableView.reloadData()
                if self.dataRecentCommemt.count == 0 {
                    self.noCommentLabel.isHidden = false
                } else {
                    self.noCommentLabel.isHidden = true
                }
            case .failure(let failure):
                print(failure)
            }
        }
    }
    func callAPIUserEvent() {
        ProfileAPI.shared.getUserEvent(id_user: AppConstant.userId ?? 0 ) { result in
            switch result {
            case .success(let success):
                let data = success.list_sukien?.compactMap {$0.sukien?.first }
                self.dataUserEvent = data!
            case .failure(let failure):
                print(failure)
            }
        }
    }
    @IBAction func backBtn(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: false)
    }
    
    @IBAction func userEventBtn(_ sender: Any) {
        let vc = UserEventViewController(nibName: "UserEventViewController", bundle: nil)
        vc.data = self.dataUserEvent
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func LogOutBtn(_ sender: Any) {
       AppConstant.logout()
        self.navigationController?.pushViewController(LoginViewController(nibName: "LoginViewController", bundle: nil), animated: true)
    }
}

extension ProfileViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataRecentCommemt.count
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DetailCommentTableViewCell", for: indexPath) as? DetailCommentTableViewCell else {
            return UITableViewCell()
        }
        cell.configCellReComment(model: dataRecentCommemt[indexPath.row])
        return cell
        
        
    }
}

extension ProfileViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
        
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailEventsViewController(data: dataRecentCommemt[indexPath.row].id_toan_bo_su_kien ?? -1 )
        vc.index = dataRecentCommemt[indexPath.row].so_thu_tu_su_kien ?? -1
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
}
