//
//  SearchInputController.swift
//  newsAlamofireFiltered
//
//  Created by Mykhailo Tsyba on 1/27/20.
//  Copyright © 2020 miketsyba. All rights reserved.
//

import UIKit

class SearchInputController: UIViewController {

	@IBOutlet weak var keywordTetxField: UITextField!
	@IBOutlet weak var dateFromTetxField: UITextField!
	@IBOutlet weak var dateToTetxField: UITextField!
	@IBOutlet weak var searchButton: UIButton!
	@IBOutlet weak var inputBackgroundView: UIView!
	@IBOutlet weak var searchActivityIndicatorView: UIActivityIndicatorView!

	@IBOutlet weak var viewBottomConstraint: NSLayoutConstraint!

	var newsArray = [NewsModel]()

    override func viewDidLoad() {
        super.viewDidLoad()

		designUI()
		searchActivityIndicatorView.isHidden = true
		let keyboardHide = UITapGestureRecognizer(target: self, action: #selector(keyboardWillHide))
		view.addGestureRecognizer(keyboardHide)

		keywordTetxField.delegate = self
    }

	@IBAction func didTapSearchButton(_ sender: Any) {

		if let keyword = keywordTetxField.text {
			if keyword != "" {
				makeRequest()
			} else {
				debugPrint("no keyword for search")
				searchAlert(title: "FATAL ERROR!!!", message: "Your keyword is Empty, Foo!!!")
			}
		}
	}
}

//MARK: - designUI
extension SearchInputController {
	func designUI() {
		inputBackgroundView.clipsToBounds = true
		inputBackgroundView.layer.cornerRadius = 10
	}
}

//MARK: - keyboardWillHide
extension SearchInputController {
	@objc func keyboardWillHide() {
		viewBottomConstraint.constant = 0
		self.view.endEditing(true)
	}
}

//MARK: - UITextFieldDelegate
extension SearchInputController: UITextFieldDelegate {
	func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
		viewBottomConstraint.constant = 250
		textField.rightViewMode = .whileEditing
		return true
	}

	func textFieldShouldClear(_ textField: UITextField) -> Bool {
		return true
	}

	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		viewBottomConstraint.constant = 0
		return true
	}
}

//MARK: - makeRequest
extension SearchInputController {
	func makeRequest() {
		searchActivityIndicatorView.isHidden = false
		searchActivityIndicatorView.startAnimating()
		let url = URL(string: "https://newsapi.org/v2/everything?q=" + (keywordTetxField.text ?? "") + "&from=2019-12-28&to=2020-01-12&pageSize=20")

		if let url = url {

			var urlRequest = URLRequest(url: url)
			urlRequest.allHTTPHeaderFields = ["X-Api-Key": "fbd6fda585054e02b88a99eb96d5f676"]
			urlRequest.httpMethod = "GET"

			let session = URLSession.shared

			session.dataTask(with: urlRequest) { (data, response, error) in
				if let jsonData = data {
					do {
						let json = try JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as? [String: Any]
						if let totalResults = json?["totalResults"] as? Int, totalResults == 0 {
							debugPrint("Total 0")
							DispatchQueue.main.async {
								self.searchActivityIndicatorView.stopAnimating()
								self.searchActivityIndicatorView.isHidden = true
								//alert no results
								self.searchAlert(title: "FATAL ERROR!!!", message: "Your keyword has no Results, Foo!!!")
							}
						} else {
							if let articles = json?["articles"] as? [[String: Any]] {
								self.parseNewsArticles(articles: articles)
								self.navigate()
							}
						}
					} catch {
						debugPrint(error)
					}
				}
			}.resume()
		}
	}
}

//MARK: - parseNewsArticles
extension SearchInputController {
	func parseNewsArticles(articles: [[String: Any]]) {
		for article in articles {

			let news = NewsModel()

			if let source = article["source"] as? [String: Any] {
				if let name = source["name"] as? String {
					news.source = name
					debugPrint(name)
				}
			}

			if let title = article["title"] as? String {
				news.title = title
				debugPrint(title)
			}

			if let description = article["description"] as? String {
				news.description = description
				debugPrint(description)
			}

			if let url = article["url"] as? String {
				news.url = url
				debugPrint(url)
			}

			if let urlToImage = article["urlToImage"] as? String {
				news.urlToImage = urlToImage
				debugPrint(urlToImage)
			}

			if let publishedAt = article["publishedAt"] as? String {
				news.publishedAt = publishedAt
				debugPrint(publishedAt)
			}
			self.newsArray.append(news)
		}
	}
}

//MARK: - navigate
extension SearchInputController {
	func navigate() {
		DispatchQueue.main.async {
			debugPrint(self.newsArray)
			debugPrint("shit")

			if self.newsArray.count > 0 {
				let storyboard = UIStoryboard(name: "Main", bundle: nil)
				let vc = storyboard.instantiateViewController(withIdentifier: "SearchResultController") as! SearchResultController

				debugPrint("newsArray before data transfer")
				vc.newsArray = self.newsArray
				self.newsArray = []
				debugPrint("newsArray after data transfer")
				self.searchActivityIndicatorView.stopAnimating()
				self.searchActivityIndicatorView.isHidden = true
				self.navigationController?.pushViewController(vc, animated: true)
			} else {
				debugPrint("shit")
			}
		}
	}
}

//MARK: - searchAlert
extension SearchInputController {
	func searchAlert(title: String, message: String) {
		let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
		let actionOK = UIAlertAction(title: "Ok", style: .default)
		alertController.addAction(actionOK)
		present(alertController, animated: true, completion: nil)
	}
}
