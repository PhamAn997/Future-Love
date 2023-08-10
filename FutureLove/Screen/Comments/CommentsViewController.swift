//
//  CommentsViewController.swift
//  FutureLove
//
//  Created by TTH on 24/07/2023.
//

import UIKit
import SETabView

class CommentsViewController: UIViewController , SETabItemProvider {
    
    var seTabBarItem: UITabBarItem? {
        return UITabBarItem(title: "", image: R.image.tab_comments(), tag: 0)
    }
    
    var dataDetail: [EventModel] = []
    var data : [DataComment] = []
    var isLoadingData = false
    var maxPage: Int = 0
    var currentPage: Int = 1
    var refreshControl: UIRefreshControl!
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var viewBackGround: UIView!
    @IBOutlet weak var commentTableView: UITableView!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewBackGround.gradient()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        setupUI()
        getComment(page: currentPage)
        callAPIgetdataComment()
        searchTextField.delegate = self
        
    }
    
    func setupUI() {
        self.navigationController?.isNavigationBarHidden = true
        commentTableView.dataSource = self
        commentTableView.delegate = self
        commentTableView.register(cellType: DetailCommentTableViewCell.self)
        commentTableView.separatorStyle = .none
        if let url = URL(string: AppConstant.linkAvatar.asStringOrEmpty()) {
            profileImage.af.setImage(withURL: url)
        }
        
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Kéo để làm mới")
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        commentTableView.refreshControl = refreshControl
    }
    @objc func refreshData() {
        callAPIgetdataComment()
        self.commentTableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    @IBAction func profileBtn(_ sender: Any) {
        self.navigationController?.pushViewController(ProfileViewController(nibName: "ProfileViewController", bundle: nil), animated: true)
    }
    
    func callAPIgetdataComment() {
        CommentAPI.shared.getLovehistory(page: 1) { result in
            switch result {
            case .success(let success):
                self.data = success.comment
                self.commentTableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    func getComment(page: Int) {
        CommentAPI.shared.getLovehistory(page: 1) { result in
            switch result {
            case .success(let success):
                self.data = success.comment
                self.maxPage = Int(success.sotrang!)
                self.commentTableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
        
    }
}
// MARK: - Extension UITableView
extension CommentsViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DetailCommentTableViewCell", for: indexPath) as? DetailCommentTableViewCell else {
            return UITableViewCell()
        }
        cell.configCellComment(model: data[indexPath.row])
        return cell
    }
}

extension CommentsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailEventsViewController(data: data[indexPath.row].id_toan_bo_su_kien ?? -1 )
        vc.index = data[indexPath.row].so_thu_tu_su_kien ?? -1
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let screenHeight = scrollView.frame.size.height
        
        if !isLoadingData && offsetY > contentHeight - screenHeight {
            isLoadingData = true
            loadMoreData()
        }
    }
    
    func loadMoreData() {
        currentPage += 1
        guard currentPage <= maxPage else { return }
        
        CommentAPI.shared.getLovehistory(page: self.currentPage) { result in
            switch result {
            case .success(let success):
                let data = success.comment
                self.data.append(contentsOf: data)
                self.commentTableView.reloadData()
            case .failure(let error):
                print(error)
            }
            self.isLoadingData = false
        }
    }
}

extension CommentsViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        guard self.searchTextField.text == "" else {return false}
        CommentAPI.shared.getSearchComment(word: self.searchTextField.text!) { result in
            switch result {
            case .success(let success):
                let data = success.list_sukien?.first?.sukien
            case .failure(let failure):
                print(failure)
            }
        }
        return true

    }
}
