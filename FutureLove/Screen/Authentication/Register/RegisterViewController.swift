//
//  RegisterViewController.swift
//  FutureLove
//
//  Created by TTH on 24/07/2023.
//

import UIKit
import Toast_Swift
import Vision


class RegisterViewController: UIViewController {
    var linkImage: String = ""
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passWordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    @IBOutlet weak var registerBtn: UIButton!
    @IBOutlet weak var errorUserName: UIView!
    @IBOutlet weak var errorEmail: UIView!
    @IBOutlet weak var errorPassword: UIView!
    @IBOutlet weak var errorConfirmPass: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        hideKeyboardWhenTappedAround()
        settingAttrLabel()
        checkValidate()
        actionImage()
    }
    
    @IBAction func actionBtnRegister(_ sender: Any) {
        guard  linkImage != "" else {
            return self.view.makeToast("Bạn chưa chọn ảnh Avatar")
        }
        showCustomeIndicator()
        RegisterAPI.shared.Regiter(email: emailTextField.text.asStringOrEmpty() ,
                                   password: passWordTextField.text.asStringOrEmpty(),
                                   user_name: userNameTextField.text.asStringOrEmpty(),
                                   link_avatar: linkImage,
                                   ip_register: AppConstant.IPAddress.asStringOrEmpty(),
                                   device_register: AppConstant.modelName ?? "iphone") { result in
            self.hideCustomeIndicator()
            switch result {
            case .success(let success):
                self.showAlert(message: success.message ?? "")
            case .failure(let failure):
                print(failure)
            }
        }
    }
    // MARK: - Validate
    
    @IBAction func changeUserName(_ sender: Any) {
        checkValidate()
    }
    
    @IBAction func changeEmail(_ sender: Any) {
        checkValidate()
    }
    
    @IBAction func changePassword(_ sender: Any) {
        checkValidate()
    }
    
    @IBAction func changeConfirmPass(_ sender: Any) {
        checkValidate()
    }
    
    private  func checkValidate() {
        let email = emailTextField.text.asStringOrEmpty()
        let password = passWordTextField.text.asStringOrEmpty()
        let confirmPassword = confirmPasswordTextField.text.asStringOrEmpty()
        let userName = userNameTextField.text.asStringOrEmpty()
        
        var isEmail: Bool = false
        var isPassword: Bool = false
        var isConfirmPassword: Bool = false
        var isUserName: Bool = false
        
        if userName.isUserName {
            isUserName = true
        } else {
            isUserName = false
        }
        
        if email.isValidEmail {
            isEmail = true
        } else {
            isEmail = false
        }
        
        if password.isValidPassword {
            isPassword = true
        } else {
            isPassword = false
        }
        
        if password != confirmPassword {
            isConfirmPassword = false
        } else {
            isConfirmPassword = true
        }
        
        if !isUserName && !userName.isEmpty {
            errorUserName.isHidden = false
        } else {
            errorUserName.isHidden = true
        }
        
        if !isEmail && !email.isEmpty {
            errorEmail.isHidden = false
        } else {
            errorEmail.isHidden = true
        }
        
        if !isPassword && !password.isEmpty {
            errorPassword.isHidden = false
        } else {
            errorPassword.isHidden = true
        }
        
        if !isConfirmPassword && !confirmPassword.isEmpty {
            errorConfirmPass.isHidden = false
        } else {
            errorConfirmPass.isHidden = true
        }
        
        if  isUserName && isEmail && isPassword && isConfirmPassword {
            registerBtn.isUserInteractionEnabled = true
            registerBtn.backgroundColor = R.color.mainOrange()
        } else {
            registerBtn.isUserInteractionEnabled = false
            registerBtn.backgroundColor = R.color.mainDisable()
        }
    }
    // MARK: - CustomAttrLabel
    func settingAttrLabel() {
        let attrText = NSMutableAttributedString.getAttributedString(fromString: "Already have an account? Login")
        attrText.apply(color: UIColor(hexString: "FFFFFF"), subString: "Login")
        loginLabel.attributedText = attrText
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapLabelProvision(tap:)))
        loginLabel.addGestureRecognizer(tap)
        loginLabel.isUserInteractionEnabled = true
        
    }
    
    @objc func tapLabelProvision(tap: UITapGestureRecognizer) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func actionBtnHiden(_ sender: Any) {
        if passWordTextField.isSecureTextEntry == true {
            passWordTextField.isSecureTextEntry = false
        } else {
            passWordTextField.isSecureTextEntry = true
        }
    }
    // MARK: - ChangeImage
    func actionImage(){
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(imageAvatarTapped(_:)))
        avatarImage.addGestureRecognizer(tapGesture)
        avatarImage.isUserInteractionEnabled = true
        
        
    }
    @objc func imageAvatarTapped(_ sender: UITapGestureRecognizer) {
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
                    if results.count == 1 {
                        avatarImage.image = image
                        guard let imageData = avatarImage.image!.jpegData(compressionQuality: 1.0) else {
                            return
                        }
                        HomeAPI.shared.uploadImage(key: "a07b4b5e0548a50248aecfb194645bac",
                                                   name: "image",
                                                   imageData: imageData) { result in
                            switch result {
                            case .success(let success):
                                self.linkImage = success.data?.url ?? ""
                            case .failure(let error):
                                print(error)
                            }
                        }
                    } else {
                        
                        showAlert(message: "Bạn cần chọn bức ảnh có duy nhất một khuôn mặt")
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

extension RegisterViewController : UIPickerViewDelegate,
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
            picker.dismiss(animated: true)
            self.detectFaces(in: selectedImage)
        } else { 
            print("Image not found")
        }
        
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
