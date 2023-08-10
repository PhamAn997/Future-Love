//
//  DetailEventsViewController.swift
//  FutureLove
//
//  Created by TTH on 28/07/2023.
//

import UIKit
import AlamofireImage

class DetailEventsViewController: UIViewController {
    var dataDetail: EventModel?
    var index: Int = -1
    var dataComment : [DataCommentEvent] = []
    var data : Int = -1
    var dataIp : [IPAddress] = []
    var fullscreenView: UIView?
    var downloadButton: UIButton?
    //    var initialTransform: CGAffineTransform = .identity
    var initialImageScale: CGFloat = 1.0
    
    @IBOutlet weak var detailImage: UIImageView!
    @IBOutlet weak var nameDetailLabel: UILabel!
    @IBOutlet weak var countView: UIButton!
    @IBOutlet weak var countComment: UIButton!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var keyboardScroll: UIScrollView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var avartarImage: UIImageView!
    @IBOutlet weak var detailEventTableView: UITableView!
    
    init(data: Int ) {
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
        callApiIP()
        callApiDetailEvent()
        callApiComentEvent()
        keyboard()
        commentTextField.delegate = self
    }
    
    func setupUI() {
        hideKeyboardWhenTappedAround()
        detailEventTableView.dataSource = self
        detailEventTableView.delegate = self
        detailEventTableView.register(cellType: DetailCommentTableViewCell.self)
        
        
        if let url = URL(string: AppConstant.linkAvatar.asStringOrEmpty()){
            avartarImage.af.setImage(withURL: url)
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        detailImage.addGestureRecognizer(tapGesture)
        detailImage.isUserInteractionEnabled = true
    }
    
    
    @IBAction func backBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: false)
    }
    
    func callApiDetailEvent() {
        DetailAPI.shared.getDetailEvent(idsukien: data) { result in
            switch result {
            case .success(let success):
                let data = success.sukien?[self.index - 1 ]
                self.titleLabel.text = data?.ten_su_kien ?? ""
                
                if let url = URL(string: data?.link_da_swap ?? ""){
                    self.detailImage.af.setImage(withURL: url)
                }
                
                self.descriptionLabel.text = data?.noi_dung_su_kien.asStringOrEmpty()
                self.nameDetailLabel.text = data?.ten_su_kien.asStringOrEmpty()
                self.countComment.setTitle("\(data?.count_comment ?? 0)", for: .normal)
                self.countView.setTitle("\(data?.count_view ?? 0)", for: .normal)
            case .failure(let failure):
                print("sai: \(failure)")
            }
        }
    }
    
    func callApiIP() {
        RegisterAPI.shared.getIP { result in
            switch result {
            case .success(let success):
                self.dataIp = [success]
                self.detailEventTableView.reloadData()
            case .failure(let failure):
                print(failure)
            }
        }
    }
    
    func callApiComentEvent() {
        DetailAPI.shared.getCommentEvent(id: index ,
                                         id_toan_bo_su_kien: "\(data)") { result in
            switch result {
            case .success(let success):
                self.dataComment = success.comment ?? []
                self.detailEventTableView.reloadData()
            case .failure(let failure):
                print(failure)
            }
        }
    }
    
    @IBAction func postCommentBtn(_ sender: Any) {
        guard commentTextField.text != "" else { return }
        DetailAPI.shared.postComments(noi_dung_cmt: commentTextField.text.asStringOrEmpty(),
                                      id_toan_bo_su_kien: "\(data) ",
                                      device_cmt: AppConstant.modelName ?? "iphone",
                                      ipComment: dataIp.first?.ip ?? "",
                                      imageattach: "",
                                      id_user: "\(AppConstant.userId ?? 0)",
                                      so_thu_tu_su_kien : "\(index)",
                                      location: dataIp.first?.city ?? "") { result in
            switch result {
            case .success:
                break
            case .failure(let failure):
                print(failure)
            }
            self.callApiComentEvent()
            self.commentTextField.text = nil
            self.detailEventTableView.reloadData()
        }
    }
    
    // MARK: - ZoomIn ZoomOut Image
    @objc func imageTapped(sender: UITapGestureRecognizer) {
        guard let tappedImageView = sender.view as? UIImageView else {
            return
        }
        
        fullscreenView = UIView(frame: view.bounds)
        fullscreenView?.backgroundColor = .black
        fullscreenView?.alpha = 0
        
        let zoomedImageView = UIImageView(frame: tappedImageView.frame)
        zoomedImageView.image = tappedImageView.image
        zoomedImageView.contentMode = .scaleAspectFit
        fullscreenView?.addSubview(zoomedImageView)
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(pinchGestureHandler))
        fullscreenView?.addGestureRecognizer(pinchGesture)
        
        downloadButton = UIButton(type: .custom)
        downloadButton?.setTitle("Tải xuống", for: .normal)
        downloadButton?.frame = CGRect(x: 20, y: 50, width: 100, height: 40)
        downloadButton?.addTarget(self, action: #selector(downloadButtonTapped), for: .touchUpInside)
        fullscreenView?.addSubview(downloadButton!)
        
        let closeButton = UIButton(frame: CGRect(x: view.bounds.width - 120, y: 50, width: 100, height: 40))
        closeButton.setTitle("Đóng", for: .normal)
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        fullscreenView?.addSubview(closeButton)
        
        if let fullscreenView = fullscreenView {
            view.addSubview(fullscreenView)
        }
        
        
        UIView.animate(withDuration: 0.3) {
            self.fullscreenView?.alpha = 1
            zoomedImageView.frame = UIScreen.main.bounds
        }
    }
    
    @objc func pinchGestureHandler(sender: UIPinchGestureRecognizer){
        if sender.state == .began {
            initialImageScale = fullscreenView!.transform.a
        }
        if sender.state == .changed {
            let scale = sender.scale
            let scaledValue = max(min(initialImageScale * scale, 2.0), initialImageScale)
            fullscreenView?.transform = CGAffineTransform(scaleX: scaledValue, y: scaledValue)
        }
        
        if sender.state == .ended {
            fullscreenView?.transform = CGAffineTransform(scaleX: initialImageScale, y: initialImageScale)
        }
    }
    @objc func closeButtonTapped() {
        // Đóng ảnh phóng to
        dismissFullscreenImage()
    }
    func dismissFullscreenImage() {
        UIView.animate(withDuration: 0.3, animations: {
            self.fullscreenView?.alpha = 0
        }) { _ in
            self.fullscreenView?.removeFromSuperview()
            self.fullscreenView = nil
        }
    }
    @objc func downloadButtonTapped() {
        let alert = UIAlertController(title: "Tải xuống", message: "Bạn có muốn tải ảnh về thư viện", preferredStyle: .alert)
        let oke = UIAlertAction(title: "Oke", style: .default) { result in
            if let image = self.detailImage.image {
                UIImageWriteToSavedPhotosAlbum(image, self, #selector(self.image(_:didFinishSavingWithError:contextInfo:)), nil)
            }
            self.view.makeToast("Download ảnh thành công")
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(oke)
        alert.addAction(cancel)
        self.present(alert, animated: true)
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            print("Lỗi khi lưu ảnh: \(error.localizedDescription)")
        } else {
            print("Ảnh đã được lưu thành công")
        }
    }
    
    // MARK: - Keyboard Scroll
    func keyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        
        let contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardFrame.height - 30, right: 0)
        keyboardScroll.contentInset = contentInset
        keyboardScroll.scrollIndicatorInsets = contentInset
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        let contentInset = UIEdgeInsets.zero
        keyboardScroll.contentInset = contentInset
        keyboardScroll.scrollIndicatorInsets = contentInset
    }
    
}
// MARK: - extension UITableView

extension DetailEventsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataComment.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DetailCommentTableViewCell", for: indexPath) as? DetailCommentTableViewCell else {
            return UITableViewCell()
        }
        cell.configCell(model: dataComment[indexPath.row])
        return cell
    }
}

extension DetailEventsViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}

extension DetailEventsViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        guard commentTextField.text != "" else { return false}
        DetailAPI.shared.postComments(noi_dung_cmt: commentTextField.text.asStringOrEmpty(),
                                      id_toan_bo_su_kien: "\(data) ",
                                      device_cmt: AppConstant.modelName ?? "iphone",
                                      ipComment: dataIp.first?.ip ?? "",
                                      imageattach: AppConstant.linkAvatar.asStringOrEmpty(),
                                      id_user: "\(AppConstant.userId ?? 0)",
                                      so_thu_tu_su_kien : "\(index)",
                                      location: dataIp.first?.city ?? "") { result in
            switch result {
            case .success:
                break
            case .failure(let failure):
                print(failure)
            }
            self.callApiComentEvent()
            self.commentTextField.text = nil
            self.detailEventTableView.reloadData()
        }
        return true
        
    }
}
