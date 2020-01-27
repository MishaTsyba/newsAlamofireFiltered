//
//  SearchResultController.swift
//  newsAlamofireFiltered
//
//  Created by Mykhailo Tsyba on 1/27/20.
//  Copyright © 2020 miketsyba. All rights reserved.
//

import UIKit

class SearchResultController: UIViewController {

	@IBOutlet weak var newsTableView: UITableView!
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var backButton: UIButton!
	@IBOutlet weak var filterButton: UIButton!
	@IBOutlet weak var backgroundView: UIView!

	var newsArray = [NewsModel]()
	var newsResponce: [String: Any]?

    override func viewDidLoad() {
        super.viewDidLoad()
		designUI()
		titleLabel.text = "Total news: \(newsArray.count)"
		newsTableView.delegate = self
		newsTableView.dataSource = self
		newsTableView.register(UINib(nibName: "NewsCell", bundle: nil), forCellReuseIdentifier: "NewsCell")
		newsTableView.reloadData()
    }

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

	}

	@IBAction func didTapFilterButton(_ sender: Any) {
		if self.newsArray.count > 0 {
			let storyboard = UIStoryboard(name: "Main", bundle: nil)
			let vc = storyboard.instantiateViewController(withIdentifier: "FilterController") as! FilterController
			self.navigationController?.pushViewController(vc, animated: true)
		} else {
			debugPrint("shit")
		}
	}

	@IBAction func didTapBackButton(_ sender: Any) {
		navigationController?.popViewController(animated: true)
	}
}

//MARK: - UITableViewDelegate
extension SearchResultController: UITableViewDelegate, UITableViewDataSource {

	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return newsArray.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell", for: indexPath) as! NewsCell
		cell.updateNewsCell(news: newsArray[indexPath.row])
		return cell
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

		debugPrint("*********** SearchResultController didSelectRowAt  **************")

		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		let vc = storyboard.instantiateViewController(withIdentifier: "NewsViewController") as! NewsViewController

		vc.newsURL = newsArray[indexPath.row].url ?? ""
		vc.newsSource = newsArray[indexPath.row].source ?? ""

		navigationController?.pushViewController(vc, animated: false)
    }

	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return UITableView.automaticDimension
	}
}

//MARK: - designUI
extension SearchResultController {
	func designUI() {
		backgroundView.clipsToBounds = true
		backgroundView.layer.cornerRadius = 10
	}
}
