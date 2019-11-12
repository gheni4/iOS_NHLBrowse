//
//  TeamListTableViewCell.swift
//  NHLBrowse
//
//  Created by Gennady Peymer on 11/10/19.
//  Copyright © 2019 Gennady Peymer. All rights reserved.
//

import Foundation
import UIKit
import WebKit

class TeamListTableViewCell: UITableViewCell {
    public var webView: WKWebView?
    
    public func setWebView(_ webView: WKWebView) {
        self.webView?.removeFromSuperview()
        self.webView = webView
        self.addSubview(self.webView!)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
