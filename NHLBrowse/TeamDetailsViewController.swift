//
//  TeamDetailsViewController.swift
//  NHLBrowse
//
//  Created by Gennady Peymer on 11/10/19.
//  Copyright © 2019 Gennady Peymer. All rights reserved.
//


import UIKit

class TeamDetailsViewController: UIViewController {
    /*    let menuButton: UIButton = {
     let button = UIButton(frame: CGRect(x: 0, y: 80, width: 40, height: 40))
     let image = UIImage(named: "hamburger-menu-icon")
     button.setImage(image, for: UIControl.State.normal)
     button.backgroundColor = .blue
     button.addTarget(self, action: #selector(handleMenuButton), for: .touchUpInside)
     return button
     }()*/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NetworkManager.shared.loadTeams()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let teamList = TeamListViewController()
        let menu = SideMenuNavigationController(rootViewController: teamList)
        menu.leftSide = true
        menu.menuWidth = 280
        teamList.menu = menu
        present(menu, animated: true, completion: nil)
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
}

