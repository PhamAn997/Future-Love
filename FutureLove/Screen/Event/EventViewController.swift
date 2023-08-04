//
//  EventViewController.swift
//  FutureLove
//
//  Created by TTH on 28/07/2023.
//

import UIKit
import AlamofireImage

class EventViewController: BaseViewController {
    
    var data : Int
    var dataDetail: [EventModel] = []
    
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var detailTableView: UITableView!
    @IBOutlet weak var keyboardScrollView: UIScrollView!
    init(data: Int) {
        self.data = data
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        backgroundView.gradient()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        callApiDetailEvent()
    }
    override func setupUI() {
        hideKeyboardWhenTappedAround()
        detailTableView.dataSource = self
        detailTableView.delegate = self
        detailTableView.register(cellType: Template1TBVCell.self)
        detailTableView.register(cellType: Template2TBVCell.self)
        detailTableView.register(cellType: Template3TBVCell.self)
        detailTableView.register(cellType: Template4TBVCell.self)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
        
        
    }
    @IBAction func btnSlideMenu(_ sender: Any) {
        let vc = SlideMenuViewController(data: dataDetail)
        vc.modalPresentationStyle = .overFullScreen
        vc.data = dataDetail
        vc.delegate = self
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromLeft
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        
        self.present(vc, animated: false)
    }
    // MARK: - Call Api
    
    func callApiDetailEvent() {
        DetailAPI.shared.getDetailEvent(idsukien: data) { result in
            switch result {
            case .success(let success):
                self.dataDetail = success.sukien ?? []
                self.detailTableView.reloadData()
            case .failure(let failure):
                print("sai: \(failure)")
            }
        }
    }
    
    
    // MARK: - Changekeyboard
    
    @objc func keyboardWillShow(notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        
        let contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardFrame.height, right: 0)
        keyboardScrollView.contentInset = contentInset
        keyboardScrollView.scrollIndicatorInsets = contentInset
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        let contentInset = UIEdgeInsets.zero
        keyboardScrollView.contentInset = contentInset
        keyboardScrollView.scrollIndicatorInsets = contentInset
    }
    
}

// MARK: - extension UITableView

extension EventViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataDetail.count
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = dataDetail[indexPath.row]
        if item.id_template == 4 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "Template4TBVCell", for: indexPath) as? Template4TBVCell else {
                return UITableViewCell()
            }
            cell.configCellDetail(model: dataDetail[indexPath.row])
            return cell
        } else if item.id_template == 3 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "Template3TBVCell", for: indexPath) as? Template3TBVCell else {
                return UITableViewCell()
            }
            cell.configCellDetail(model: dataDetail[indexPath.row])
            return cell
        } else if item.id_template == 2 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "Template2TBVCell", for: indexPath) as? Template2TBVCell else {
                return UITableViewCell()
            }
            cell.configCellDetail(model: dataDetail[indexPath.row])
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "Template1TBVCell", for: indexPath) as? Template1TBVCell else {
                return UITableViewCell()
            }
            cell.configCellDetail(model: dataDetail[indexPath.row])
            return cell
        }
        
        
        
    }
}

extension EventViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        let height = UIScreen.main.bounds.size.width * 200 / 390
//        return height
        return UITableView.automaticDimension
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailEventsViewController(data: data)
        vc.index = dataDetail[indexPath.row].so_thu_tu_su_kien ?? -1
        vc.dataDetail = dataDetail[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension EventViewController: SlideMenuprotocol {
    func navigeteHome() {
        self.dismiss(animated: false)
        self.navigationController?.popToRootViewController(animated: false)
    }
    
    func navigateDetailComment(at index: Int, dataEvent: EventModel) {
        let vc = DetailEventsViewController(data: data)
        vc.index = index
        vc.dataDetail = dataEvent
        self.dismiss(animated: false)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
