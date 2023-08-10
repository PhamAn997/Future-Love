//
//  LoveViewController.swift
//  FutureLove
//
//  Created by TTH on 24/07/2023.
//

import UIKit
import SETabView
import Vision
import Toast_Swift

class LoveViewController: BaseViewController, SETabItemProvider {
    
    var seTabBarItem: UITabBarItem? {
        return UITabBarItem(title: "", image: R.image.tab_love(), tag: 0)
    }
    
    var currentImageType: ChooseImageType = .boy
    var imageboyLink: String = ""
    var imageGirlLink: String = ""
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var addImageBoy: UIImageView!
    @IBOutlet weak var boyImage: UIImageView!
    @IBOutlet weak var girlImage: UIImageView!
    @IBOutlet weak var addImage: UIImageView!
    @IBOutlet weak var boyNameTextField: UITextField!
    @IBOutlet weak var girlNameTextField: UITextField!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        backgroundView.gradient()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        actionImage()
        
    }
    
    override func setupUI() {
        hideKeyboardWhenTappedAround()
        addImageBoy.layer.cornerRadius = UIScreen.main.bounds.size.width * 0.4 / 2
        boyImage.layer.cornerRadius = UIScreen.main.bounds.size.width * 0.4 / 2
        girlImage.layer.cornerRadius = UIScreen.main.bounds.size.width * 0.4 / 2
        addImage.layer.cornerRadius = UIScreen.main.bounds.size.width * 0.4 / 2
    }
    
    @IBAction func startEventBtn(_ sender: Any) {
        guard self.boyNameTextField.text != "" && self.girlNameTextField.text != "" && self.imageboyLink != "" && self.imageGirlLink != "" else {
            if self.imageGirlLink == "" || self.imageboyLink == "" {
                self.view.makeToast("Vui lòng chọn đầy đủ 2 ảnh", position: .top)
            } else if self.boyNameTextField.text == "" || self.girlNameTextField.text == "" {
                self.view.makeToast("Vui lòng nhập tên đầy đủ", position: .top)
            }
            return
        }
        showCustomeIndicator()
        LoveAPI.shared.getEvents(Link_img1: imageboyLink,
                                 Link_img2: imageGirlLink,
                                 device_them_su_kien: AppConstant.modelName ?? "iphone",
                                 ip_them_su_kien: AppConstant.IPAddress.asStringOrEmpty(),
                                 id_user: "\(AppConstant.userId.asStringOrEmpty())",
                                 ten_nam: boyNameTextField.text.asStringOrEmpty(),
                                 ten_nu: girlNameTextField.text.asStringOrEmpty()) { result in
            self.hideCustomeIndicator()
            switch result {
            case .success(let success):
                let data = success.sukien?.first?.id_toan_bo_su_kien ?? -1
                let vc = EventViewController(data: data)
                self.navigationController?.pushViewController(vc, animated: false)
            case .failure(let failure):
                print(failure)
            }
            
        }
        
    }
    
    func actionImage(){
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(imageBoyTapped(_:)))
        boyImage.addGestureRecognizer(tapGesture)
        boyImage.isUserInteractionEnabled = true
        
        let tapaGesture = UITapGestureRecognizer(target: self,
                                                 action: #selector(imageGirlTapped(_:)))
        girlImage.addGestureRecognizer(tapaGesture)
        girlImage.isUserInteractionEnabled = true
    }
    
    @objc func imageBoyTapped(_ sender: UITapGestureRecognizer) {
        currentImageType = .boy
        let ac = UIAlertController(title: "Select Image", message: "Select image from", preferredStyle: .actionSheet)
        let cameraBtn = UIAlertAction(title: "Camera", style: .default) {_ in
            self.showImagePicker(selectedSource: .camera)
        }
        let libaryBtn = UIAlertAction(title: "Libary", style: .default) { _ in
            self.showImagePicker(selectedSource: .photoLibrary)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel){ _ in
            self.dismiss(animated: true)
        }
        ac.addAction(cameraBtn)
        ac.addAction(libaryBtn)
        ac.addAction(cancel)
        self.present(ac, animated: true)
        
        
    }
    
    @objc func imageGirlTapped(_ sender: UITapGestureRecognizer) {
        currentImageType = .girl
        let ac = UIAlertController(title: "Select Image", message: "Select image from", preferredStyle: .actionSheet)
        let cameraBtn = UIAlertAction(title: "Camera", style: .default) {_ in
            self.showImagePicker(selectedSource: .camera)
        }
        let libaryBtn = UIAlertAction(title: "Libary", style: .default) { _ in
            self.showImagePicker(selectedSource: .photoLibrary)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel){ _ in
            self.dismiss(animated: true)
        }
        ac.addAction(cameraBtn)
        ac.addAction(libaryBtn)
        ac.addAction(cancel)
        self.present(ac, animated: true)
    }
    
    func detectFaces(in image: UIImage)  {
        if let cgImage = image.cgImage {
            let requestHandler = VNImageRequestHandler(cgImage: cgImage, orientation: .up, options: [:])
            do {
                let faceDetectionRequest = VNDetectFaceRectanglesRequest()
                try requestHandler.perform([faceDetectionRequest])
                if let results = faceDetectionRequest.results {
                    if self.currentImageType == .boy {
                        if results.count == 1 {
                            boyImage.image = image
                            guard let imageData = boyImage.image!.jpegData(compressionQuality: 1.0) else {
                                return
                            }
                            HomeAPI.shared.uploadImage(key: "a07b4b5e0548a50248aecfb194645bac",
                                                       name: "image",
                                                       imageData: imageData) { result in
                                switch result {
                                case .success(let success):
                                    self.imageboyLink = success.data?.url ?? ""
                                case .failure(let error):
                                    print(error)
                                }
                            }
                        } else {
                            
                            showAlert(message: "Bạn cần chọn bức ảnh có duy nhất một khuôn mặt")
                        }
                    } else {
                        if results.count == 1 {
                            girlImage.image = image
                            guard let imageData = girlImage.image!.jpegData(compressionQuality: 1.0) else {
                                return
                            }
                            HomeAPI.shared.uploadImage(key: "a07b4b5e0548a50248aecfb194645bac",
                                                       name: "image",
                                                       imageData: imageData) { result in
                                switch result {
                                case .success(let success):
                                    self.imageGirlLink = success.data?.url ?? ""
                                case .failure(let error):
                                    print(error)
                                }
                            }
                        } else {
                            
                            showAlert(message: "Bạn cần chọn bức ảnh có duy nhất một khuôn mặt")
                        }
                    }
                }
            } catch {
                print("Error: \(error)")
            }
        }
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Đồng ý", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
}

extension LoveViewController : UIPickerViewDelegate,
                               UINavigationControllerDelegate,
                               UIImagePickerControllerDelegate {
    func showImagePicker(selectedSource: UIImagePickerController.SourceType) {
        guard UIImagePickerController.isSourceTypeAvailable(selectedSource) else {
            return
        }
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = selectedSource
        imagePickerController.allowsEditing = false
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            if self.currentImageType == .boy {
                picker.dismiss(animated: true)
                self.detectFaces(in: selectedImage)
            } else {
                picker.dismiss(animated: true)
                self.detectFaces(in: selectedImage)
            }
        } else {
            print("Image not found")
        }
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

extension LoveViewController : UITextFieldDelegate {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.dismiss(animated: true)
        textField.resignFirstResponder()
        return true
    }
}

enum ChooseImageType {
    case boy
    case girl
}
