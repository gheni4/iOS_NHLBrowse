//
//  PlayerDetailsViewController.swift
//  NHLBrowse
//
//  Created by Gennady Peymer on 11/11/19.
//  Copyright © 2019 Gennady Peymer. All rights reserved.
//

import Foundation
import UIKit

class PlayerDetailsViewController: UIViewController, Updating {
    let countryNameLabel = UILabel()
    let flagLabel = UILabel()
    
    private let backButton = UIButton()
    
    override func viewDidLoad() {
        view.backgroundColor = .white
        dataUpdated()
        setupLayout()
    }
    
    func setupLayout() {
        view.addSubview(countryNameLabel)
        countryNameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            countryNameLabel.widthAnchor.constraint(equalTo: view.widthAnchor),
            countryNameLabel.heightAnchor.constraint(equalToConstant: 80),
            countryNameLabel.centerXAnchor.constraint(equalTo:view.centerXAnchor),
            countryNameLabel.topAnchor.constraint(equalTo:view.topAnchor, constant: 70)
        ])
        countryNameLabel.textAlignment = .center
        countryNameLabel.font = UIFont (name: "HelveticaNeue", size: 30)
        
        view.addSubview(flagLabel)
        flagLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            flagLabel.widthAnchor.constraint(equalToConstant: 250),
            flagLabel.heightAnchor.constraint(equalToConstant: 250),
            flagLabel.centerXAnchor.constraint(equalTo:view.centerXAnchor),
            flagLabel.centerYAnchor.constraint(equalTo:view.centerYAnchor)
        ])
        flagLabel.textAlignment = .center
        flagLabel.font = UIFont (name: "HelveticaNeue", size: 200)
        
        view.addSubview(backButton)
        backButton.setImage(UIImage(named: "backButton"), for: UIControl.State.normal)
        backButton.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
              
        backButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backButton.widthAnchor.constraint(equalToConstant: 40),
            backButton.heightAnchor.constraint(equalToConstant: 40),
            backButton.leadingAnchor.constraint(equalTo:view.leadingAnchor, constant: 10),
            backButton.topAnchor.constraint(equalTo:view.topAnchor, constant: 50),
        ])
        
    }
    
    func dataUpdated() {
        if (DataModel.shared.playerNationality == "") { return }
        let iso3code = DataModel.shared.playerNationality
        let isoCountryOrNil = IsoCountryCodes.find(key: iso3code)
        guard let isoCountry = isoCountryOrNil else { return }
        countryNameLabel.text = isoCountry.name
        flagLabel.text = emojiFlag(countryCode: isoCountry.alpha2)
    }
    
    func emojiFlag(countryCode: String) -> String {
        var string = ""
        for uS in countryCode.unicodeScalars {
            string.unicodeScalars.append(UnicodeScalar(127397 + uS.value)!)
        }
        return string
    }
    
    @objc func backTapped() {
        DataModel.shared.setControllers(playerDetailsViewController: nil)
        DataModel.shared.invalidateNationality()
        dismiss(animated: true)
    }
}
