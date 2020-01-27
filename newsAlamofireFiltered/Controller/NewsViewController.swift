//
//  NewsViewController.swift
//  newsAlamofireFiltered
//
//  Created by Mykhailo Tsyba on 1/27/20.
//  Copyright © 2020 miketsyba. All rights reserved.
//

import UIKit
import WebKit

class NewsViewController: UIViewController {

	@IBOutlet weak var newsWKWebView: WKWebView!
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var backButton: UIButton!
	@IBOutlet weak var backgroundView: UIView!

	var newsURL = String()
	var newsSource = String()

    override func viewDidLoad() {
        super.viewDidLoad()
		debugPrint(newsURL)
		titleLabel.text = "News by: " + newsSource
		if let url = URL(string: newsURL) {
			newsWKWebView.load(URLRequest(url: url))
		}

        // Do any additional setup after loading the view.
    }

	@IBAction func didTapBackButton(_ sender: Any) {
		navigationController?.popViewController(animated: true)
	}
}
