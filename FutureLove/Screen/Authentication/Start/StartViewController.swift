//
//  StartViewController.swift
//  FutureLove
//
//  Created by TTH on 01/08/2023.
//

import UIKit
import DeviceKit

class StartViewController: UIViewController {

    @IBOutlet weak var luonSong2Image: UIImageView!
    @IBOutlet weak var luonSongImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let device = Device.current
        let modelName = device.description
        AppConstant.modelName = modelName
        
        UIView.animate(withDuration: 3.0, animations: {
            self.luonSongImage.transform = CGAffineTransform(translationX: -150 , y: -200)
                }) { _ in
                    
                }
        UIView.animate(withDuration: 3.0, animations: {
            self.luonSong2Image.transform = CGAffineTransform(translationX: 160 , y: -210)
                }) { _ in
                    if AppConstant.userId == nil {
                        self.navigationController?.pushViewController(LoginViewController(nibName: "LoginViewController", bundle: nil), animated: true)
                    } else {

                        self.navigationController?.setRootViewController(viewController: TabbarViewController(),
                                                                         controllerType: TabbarViewController.self)
                    }
                    
                }
    }



}
