//
//  LoginViewController.swift
//  FutureLove
//
//  Created by TTH on 24/07/2023.
//

import UIKit
import Toast_Swift

class LoginViewController: UIViewController {
    
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passWordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        hideKeyboardWhenTappedAround()
        settingAttrLabel()
        callApiIP()
        
    }
    
    func callApiIP(){
        RegisterAPI.shared.getIP { result in
            switch result {
            case .success(let success):
                AppConstant.saveIp(model: success)
            case .failure(let failure):
                print(failure)
            }
        }
    }
    
    @IBAction func btnLogin(_ sender: Any) {
        guard userNameTextField.text != "" && passWordTextField.text != "" else {
            if userNameTextField.text == "" {
                self.view.makeToast("UserName or Email không được để trống", position: .top)
            } else {
                self.view.makeToast("Password không được để trống",position: .top)
            }
             return
        }
        showCustomeIndicator()
        LoginAPI.shared.Login(email_or_username: userNameTextField.text.asStringOrEmpty(),
                              password: passWordTextField.text.asStringOrEmpty()) { result in
            
            self.hideCustomeIndicator()
            switch result {
            case .success(let success):
                guard success.id_user != nil else {
                    self.view.makeToast(success.ketqua, position: .top)
                    return
                }
                
                AppConstant.saveUser(model: success)
                self.navigationController?.setRootViewController(viewController: TabbarViewController(),
                                                                 controllerType: TabbarViewController.self)
                
            case .failure(let failure):
                print(failure)
            }
            
        }
    }
    
    @IBAction func actionBtnHiden(_ sender: Any) {
        if passWordTextField.isSecureTextEntry == true {
            passWordTextField.isSecureTextEntry = false
        } else {
            passWordTextField.isSecureTextEntry = true
        }
    }
    
    @IBAction func btnResetPass(_ sender: Any) {
        self.navigationController?.pushViewController(FogotPassViewController(nibName: "FogotPassViewController", bundle: nil), animated: true)
    }
    
    func settingAttrLabel() {
        let attrText = NSMutableAttributedString.getAttributedString(fromString: "Don’t have an account? Register")
        attrText.apply(color: UIColor(hexString: "FFFFFF"), subString: "Register")
        registerLabel.attributedText = attrText
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapLabelProvision(tap:)))
        registerLabel.addGestureRecognizer(tap)
        registerLabel.isUserInteractionEnabled = true
    }
    
    @objc func tapLabelProvision(tap: UITapGestureRecognizer) {
        let vc = RegisterViewController(nibName: "RegisterViewController", bundle: nil)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
