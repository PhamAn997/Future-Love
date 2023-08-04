//
//  FogotPassViewController.swift
//  FutureLove
//
//  Created by TTH on 26/07/2023.
//

import UIKit
import Toast_Swift

class FogotPassViewController: BaseViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        hideKeyboardWhenTappedAround()
        
    }
    
    
    @IBAction func backBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: false)
    }
    
    @IBAction func resetPasswordBtn(_ sender: Any) {
        guard emailTextField.text != "" else {
             self.view.makeToast("Email không được để trống")
            return
        }
        showCustomeIndicator()
        LoginAPI.shared.ResetPassword(mail: emailTextField.text!) { result in
            switch result {
            case .success(let success):
                self.view.makeToast(success.message)
                self.hideCustomeIndicator()
                self.emailTextField.text = nil
            case .failure(let failure):
                print(failure)
            }
        }
        
    }
}
