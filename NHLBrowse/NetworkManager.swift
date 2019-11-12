//
//  NetworkManager.swift
//  NHLBrowse
//
//  Created by Gennady Peymer on 11/10/19.
//  Copyright © 2019 Gennady Peymer. All rights reserved.
//

import Foundation
import UIKit
import WebKit

class NetworkManager {
    let baseURLForLink = "https://statsapi.web.nhl.com"
    let baseURL = "https://statsapi.web.nhl.com/api/v1/"
    let teamsURL = "teams/"
    let teamURLFormat = "teams/%d/roster/"
    let logoURLFormat = "https://www-league.nhlstatic.com/nhl.com/builds/site-core/859472b87b7fa15f2f1331f5f72b3c722331138c_1572970812/images/logos/team/current/team-%d-light.svg"
    static let shared = NetworkManager()
    
    typealias CompletionHandler = (_ json: Any) -> Void
    func getDataFromURL(_ url: URL, completion: @escaping CompletionHandler) {
        let session = URLSession.shared
        let task = session.dataTask(with: url, completionHandler: { data, response, error in
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: [])
                completion(json)
            } catch {
                print("JSON error: \(error.localizedDescription)")
            }
        })
        task.resume()
    }
    
    func loadTeams() {
        guard let url = URL(string: baseURL + teamsURL) else { return }
        getDataFromURL(url) { json in
            var result: Array<teamStruct> = Array()
            if let dictionary = json as? [String: Any] {
                if let teamsArray = dictionary["teams"] as? [Any] {
                    for team in teamsArray {
                        let teamDict = team as! NSDictionary
                        let teamId: Int = teamDict["id"] as? Int ?? 0
                        let newTeam = teamStruct(id: teamId, name: teamDict["name"] as? String, logo: nil)
                        result.append(newTeam)
                    }
                }
            }
            DispatchQueue.main.async {
                DataModel.shared.updateTeamList(result)
            }
        }
    }
    
    func loadTeam(teamId: Int) {
        guard let url = URL(string: baseURL + String(format: teamURLFormat, teamId)) else { return }
        getDataFromURL(url) { json in
            var result: Array<playerStruct> = Array()
            if let dictionary = json as? [String: Any] {
                if let roster = dictionary["roster"] as? [Any] {
                    for person in roster {
                        let playerDict = person as! NSDictionary
                        let playerNumber = playerDict["jerseyNumber"] as? String
                        let personDetails = playerDict["person"] as! NSDictionary
                        let playerName = personDetails["fullName"] as? String
                        let playerLink = personDetails["link"] as? String
                        let positionDetails = playerDict["position"] as! NSDictionary
                        let playerPosition = positionDetails["name"] as? String
                        
                        let newPlayer = playerStruct(number: playerNumber,
                                                     name: playerName,
                                                     position: playerPosition,
                                                     link: playerLink)
                        result.append(newPlayer)
                    }
                }
            }
            DispatchQueue.main.async {
                DataModel.shared.updatePlayersList(result)
            }
        }
    }
    
    func loadCountryCode(playerLink: String) {
        let url = URL(string: baseURLForLink + playerLink)
        getDataFromURL(url!) { json in
            if let dictionary = json as? [String: Any] {
                if let array = dictionary["people"] as? [Any] {
                    let person = array.first
                    let dict = person as! NSDictionary
                    let playerNationalityOrNil = dict["nationality"] as? String
                    guard let playerNationality = playerNationalityOrNil else { return }
                    DataModel.shared.updatePlayerNationality(playerNationality)
                }
            }
        }
    }
    
    func loadLogo(teamId :Int, webView: WKWebView) {
        let logoURL = URL(string: String(format: logoURLFormat, teamId))
        let request = URLRequest(url: logoURL!)
        webView.load(request)
        webView.backgroundColor = .lightGray
    }
}
