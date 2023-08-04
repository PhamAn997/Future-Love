//
//  TabbarViewController.swift
//  FutureLove
//
//  Created by TTH on 25/07/2023.
//

import UIKit
import Rswift
import SETabView

class TabbarViewController: SETabViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set tab bar look
        setTabColors(backgroundColor: R.color.tabbar() ?? .red,
                     ballColor: .clear,
                     tintColor: .black,
                     unselectedItemTintColor: .white,
                     barTintColor: .clear)
        
        // set view controllers
        setViewControllers(getViewControllers())
    }
    
    private func getViewControllers() -> [UIViewController] {
        return [
            HomeViewController(nibName: "HomeViewController", bundle: nil),
            CommentsViewController(nibName: "CommentsViewController", bundle: nil),
            LoveViewController(nibName: "LoveViewController", bundle: nil)
           
        ]
    }


}
