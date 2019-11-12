//
//  TeamDetailsViewController.swift
//  NHLBrowse
//
//  Created by Gennady Peymer on 11/10/19.
//  Copyright © 2019 Gennady Peymer. All rights reserved.
//

import UIKit

class TeamDetailsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, Updating, SideMenuNavigationControllerDelegate {
    
    let panelView = UIView()
    let tableView = UITableView()
    let panelSize: CGFloat = 100
    let teamList = TeamListViewController()
    var menu: SideMenuNavigationController
    var filterPosition: String?
         
    required init?(coder: NSCoder) {
        menu = SideMenuNavigationController(rootViewController: teamList)
        menu.leftSide = true
        menu.menuWidth = 280
        teamList.menu = menu
        super.init(coder: coder)
        menu.sideMenuDelegate = self
        menu.statusBarEndAlpha = 0
        menu.navigationBar.isHidden = true
    }
    
    let menuButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "linesIcon")
        button.setImage(image, for: UIControl.State.normal)
        button.addTarget(self, action: #selector(handleMenuButton), for: .touchUpInside)
        return button
    }()
    
    let sortByNumberButton: UIButton = {
        let button = UIButton()
        button.setTitle("#", for: UIControl.State.normal)
        button.setTitleColor(.white, for: UIControl.State.normal)
        button.setTitleColor(.black, for: UIControl.State.highlighted)
        button.backgroundColor = .red
        button.layer.cornerRadius = 20;
        button.addTarget(self, action: #selector(handleSortByNumber), for: .touchUpInside)
        return button
    }()
    
    let sortByNameButton: UIButton = {
        let button = UIButton()
        button.setTitle("Name", for: UIControl.State.normal)
        button.setTitleColor(.white, for: UIControl.State.normal)
        button.setTitleColor(.gray, for: UIControl.State.highlighted)
        button.backgroundColor = .black
        button.layer.cornerRadius = 20;
        button.addTarget(self, action: #selector(handleSortByName), for: .touchUpInside)
        return button
    }()
    
    let filterPositionButton: UIButton = {
        let button = UIButton()
        button.setTitle("Position", for: UIControl.State.normal)
        button.setTitleColor(.white, for: UIControl.State.normal)
        button.setTitleColor(.black, for: UIControl.State.highlighted)
        button.backgroundColor = .blue
        button.layer.cornerRadius = 20;
        button.addTarget(self, action: #selector(handleFilterPosition), for: .touchUpInside)
        return button
    }()
    
    
    //MARK: TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if filterPosition != nil {
            let filtered = DataModel.shared.playersList.filter({ $0.position == filterPosition })
            return filtered.count
        }
        return DataModel.shared.playersList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "playerCell") ??
            UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "playerCell")
       
        let playerList = DataModel.shared.playersList.filter({ filterPosition == nil || $0.position == filterPosition })
        let player = playerList[indexPath.row]
        
        let playerDescription = String(format: "#%@: %@, %@", player.number!, player.name!, player.position!)
        cell.textLabel?.text = playerDescription
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let playerDetailsViewController = PlayerDetailsViewController()
        playerDetailsViewController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        self.present(playerDetailsViewController, animated: true)
        
        DataModel.shared.setControllers(playerDetailsViewController: playerDetailsViewController)
        let player = DataModel.shared.playersList[indexPath.row]
        NetworkManager.shared.loadCountryCode(playerLink: player.link!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.frame = CGRect(x: view.frame.minX,
                                 y: view.frame.minY + panelSize,
                                 width: view.frame.width,
                                 height: view.frame.height - panelSize)
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
        
        panelView.frame = CGRect(x: view.frame.minX,
                                 y: view.frame.minY,
                                 width: view.frame.width,
                                 height: view.frame.origin.y + panelSize)
        panelView.backgroundColor = .white
        view.addSubview(panelView)
        
        panelView.addSubview(menuButton)
        menuButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            menuButton.leadingAnchor.constraint(equalTo: panelView.leadingAnchor, constant: 20),
            menuButton.topAnchor.constraint(equalTo: panelView.topAnchor, constant: 50),
            menuButton.widthAnchor.constraint(equalToConstant: 40),
            menuButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        panelView.addSubview(sortByNumberButton)
        sortByNumberButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            sortByNumberButton.leadingAnchor.constraint(equalTo: menuButton.trailingAnchor, constant: 10),
            sortByNumberButton.topAnchor.constraint(equalTo: panelView.topAnchor, constant: 50),
            sortByNumberButton.widthAnchor.constraint(equalToConstant: 90),
            sortByNumberButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        panelView.addSubview(sortByNameButton)
        sortByNameButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            sortByNameButton.leadingAnchor.constraint(equalTo: sortByNumberButton.trailingAnchor, constant: 10),
            sortByNameButton.topAnchor.constraint(equalTo: panelView.topAnchor, constant: 50),
            sortByNameButton.widthAnchor.constraint(equalToConstant: 90),
            sortByNameButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        panelView.addSubview(filterPositionButton)
        filterPositionButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            filterPositionButton.leadingAnchor.constraint(equalTo: sortByNameButton.trailingAnchor, constant: 10),
            filterPositionButton.topAnchor.constraint(equalTo: panelView.topAnchor, constant: 50),
            filterPositionButton.widthAnchor.constraint(equalToConstant: 90),
            filterPositionButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        panelView.alpha = 0
        
        NetworkManager.shared.loadTeams()
        DataModel.shared.setControllers(teamDetailsViewController: self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if animated {
            showMenu()
        }
    }
    
    func dataUpdated() {
        tableView.reloadData()
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    //MARK: Button handlers
    @objc func handleMenuButton() {
        UIView.animate(withDuration: 0.2) {
            self.panelView.alpha = 0
        }
        showMenu()
    }
    
    @objc func handleSortByNumber() {
        DataModel.shared.sortPlayersByNumber()
    }
    
    @objc func handleSortByName() {
        DataModel.shared.sortPlayersByName()
    }
    
    @objc func handleFilterPosition() {
        let alert = UIAlertController(title: nil,
                                      message: nil,
                                      preferredStyle: UIAlertController.Style.actionSheet)
        alert.addAction(UIAlertAction(title: "Clear", style: UIAlertAction.Style.cancel, handler: { _ in
            self.filterPosition = nil
            self.dataUpdated()
        }))
        
        let unique = Set(DataModel.shared.playersList.map({ $0.position }))
        for position in unique {
            alert.addAction(UIAlertAction(title: position,
                                          style: UIAlertAction.Style.default,
                                          handler: {(_: UIAlertAction!) in
                                            self.filterPosition = position
                                            self.dataUpdated()
            }))
        }
        self.present(alert, animated: true, completion: nil)
    }
    
    private func showMenu() {
        present(menu, animated: true, completion: nil)
    }
    
    func sideMenuDidDisappear(menu: SideMenuNavigationController, animated: Bool) {
        UIView.animate(withDuration: 0.2) {
            self.panelView.alpha = 1.0
        }
    }
    
    deinit {
        DataModel.shared.setControllers(playerDetailsViewController: nil)
    }
}

