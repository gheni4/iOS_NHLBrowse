//
//  TeamListViewController.swift
//  NHLBrowse
//
//  Created by Gennady Peymer on 11/10/19.
//  Copyright © 2019 Gennady Peymer. All rights reserved.
//

import Foundation
import UIKit
import WebKit

class TeamListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, Updating  {
    public var menu: SideMenuNavigationController?
    let tableView = UITableView()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        DataModel.shared.teamsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "teamCell") as? TeamListTableViewCell ??
            TeamListTableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "teamCell")
    
        let paragraph = NSMutableParagraphStyle()
        paragraph.firstLineHeadIndent = 70
        let atributed = NSAttributedString(string: DataModel.shared.teamsList[indexPath.row].name!,
                                           attributes: [NSAttributedString.Key.paragraphStyle: paragraph])
        cell.textLabel?.attributedText = atributed
        let teamId = DataModel.shared.teamsList[indexPath.row].id
        let webViewOrNil = DataModel.shared.teamsList[indexPath.row].logo
        if webViewOrNil == nil {
            let webView = WKWebView()
            webView.frame = CGRect(x: 10, y: 10, width: 70, height: 60)
            webView.scrollView.contentInset = UIEdgeInsets(top: 0, left: -90, bottom: 0, right: 0)
            NetworkManager.shared.loadLogo(teamId: teamId, webView: webView)
            DataModel.shared.teamsList[indexPath.row].logo = webView
            cell.setWebView(webView)
        }
        else {
            cell.setWebView(webViewOrNil!)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        menu!.dismissMenu()
        let teamId = DataModel.shared.teamsList[indexPath.row].id
        NetworkManager.shared.loadTeam(teamId: teamId)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        80
    }
    
    func dataUpdated() {
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.frame = view.frame
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
        
        DataModel.shared.setControllers(teamsViewController: self)
    }
    
    deinit {
        DataModel.shared.setControllers(playerDetailsViewController: nil)
    }
}
