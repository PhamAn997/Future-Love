//
//  HomeViewController.swift
//  FutureLove
//
//  Created by TTH on 24/07/2023.
//

import UIKit
import SETabView
import AlamofireImage

class HomeViewController: UIViewController, SETabItemProvider {
    var data: [Sukien] = []
    var seTabBarItem: UITabBarItem? {
        return UITabBarItem(title: "", image: UIImage(named: "tab_home"), tag: 0)
    }
 
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var viewBackground: UIView!
    @IBOutlet weak var homeTableView: UITableView!
    
    @IBOutlet weak var profileBtn: UIButton!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewBackground.gradient()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        setupUI()
        callApiHome()
      
    }
    
    func setupUI() {
        homeTableView.delegate = self
        homeTableView.dataSource = self
        homeTableView.register(cellType: Template1TBVCell.self)
        homeTableView.register(cellType: Template2TBVCell.self)
        homeTableView.register(cellType: Template3TBVCell.self)
        homeTableView.register(cellType: Template4TBVCell.self)
        homeTableView.separatorStyle = .none
        
        if let url = URL(string: AppConstant.linkAvatar.asStringOrEmpty()){
            avatarImage.af.setImage(withURL: url)
        }
    }
    
    @IBAction func searchBtn(_ sender: Any) {
       
    }
    func callApiHome() {
        HomeAPI.shared.getLovehistory(page: 1) { result in
            switch result {
            case .success(let success):
                let data = success.list_sukien?.compactMap {$0.sukien?.first }
                self.data = data!
                self.homeTableView.reloadData()
            case .failure(let failure):
                print(failure)
            }
        }
    }
    @IBAction func actionNextProfile(_ sender: Any) {
        let vc = ProfileViewController(nibName: "ProfileViewController", bundle: nil)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
// MARK: - extension UITableView

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = data[indexPath.row]
        if item.id_template == 4 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "Template4TBVCell", for: indexPath) as? Template4TBVCell else {
                return UITableViewCell()
            }
            cell.configCell(model: data[indexPath.row])
            return cell
        } else if item.id_template == 3 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "Template3TBVCell", for: indexPath) as? Template3TBVCell else {
                return UITableViewCell()
            }
            cell.configCell(model: data[indexPath.row])
            return cell
        } else if item.id_template == 2 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "Template2TBVCell", for: indexPath) as? Template2TBVCell else {
                return UITableViewCell()
            }
            cell.configCell(model: data[indexPath.row])
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "Template1TBVCell", for: indexPath) as? Template1TBVCell else {
                return UITableViewCell()
            }
            cell.configCell(model: data[indexPath.row])
            return cell
        }
        
    }
    
}

extension HomeViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height = tableView.frame.height / 3
        //        UIScreen.main.bounds.size.width * 200 / 390
        return height
//        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = EventViewController(data: data[indexPath.row].id_toan_bo_su_kien ?? 0)
//        vc.data = data[indexPath.row].id_toan_bo_su_kien ?? 0
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
