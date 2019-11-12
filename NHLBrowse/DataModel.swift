//
//  DataModel.swift
//  NHLBrowse
//
//  Created by Gennady Peymer on 11/10/19.
//  Copyright © 2019 Gennady Peymer. All rights reserved.
//

import Foundation
import UIKit
import WebKit

struct teamStruct {
    var id: Int
    var name: String?
    var logo: WKWebView?
}

struct playerStruct {
    var number: String?
    var name: String?
    var position: String?
    var link: String?
}

protocol Updating {
    func dataUpdated()
}

class DataModel {
    static let shared = DataModel(teamsViewController: nil)
    public var teamsList: Array<teamStruct>
    public var playersList: Array<playerStruct>
    public var playerNationality: String
    private var teamsViewController: Updating?
    private var teamDetailsViewController: Updating?
    private var playerDetailsViewController: Updating?
    
    public init(teamsViewController: Updating?) {
        teamsList = Array()
        playersList = Array()
        playerNationality = ""
        self.teamsViewController = teamsViewController
    }
    
    public func updateTeamList(_ teamsList: Array<teamStruct>) {
        DispatchQueue.main.async {
            self.teamsList = teamsList
            self.teamsViewController?.dataUpdated()
        }
    }
    
    public func updatePlayersList(_ playersList: Array<playerStruct>) {
        DispatchQueue.main.async {
            self.playersList = playersList
            self.teamDetailsViewController?.dataUpdated()
        }
    }
    
    public func updatePlayerNationality(_ nationality: String) {
        DispatchQueue.main.async {
            self.playerNationality = nationality
            self.playerDetailsViewController?.dataUpdated()
        }
    }
    
    public func invalidateNationality() {
        self.playerNationality = ""
    }
    
    public func setControllers(teamsViewController: Updating?) {
        DispatchQueue.main.async {
            self.teamsViewController = teamsViewController
        }
    }
    
    public func setControllers(teamDetailsViewController: Updating?) {
        DispatchQueue.main.async {
            self.teamDetailsViewController = teamDetailsViewController
        }
    }
    
    public func setControllers(playerDetailsViewController: Updating?) {
        DispatchQueue.main.async {
            self.playerDetailsViewController = playerDetailsViewController
        }
    }
    
    public func sortPlayersByNumber() {
        DispatchQueue.main.async {
            self.playersList = self.playersList.sorted(by: { Int($0.number!)! < Int($1.number!)! })
            self.teamDetailsViewController?.dataUpdated()
        }
    }
    
    public func sortPlayersByName() {
        DispatchQueue.main.async {
            self.playersList = self.playersList.sorted(by: { $0.name! < $1.name! })
            self.teamDetailsViewController?.dataUpdated()
        }
    }
}


