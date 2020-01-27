//
//  NewsCell.swift
//  newsAlamofireFiltered
//
//  Created by Mykhailo Tsyba on 1/27/20.
//  Copyright © 2020 miketsyba. All rights reserved.
//

import UIKit

class NewsCell: UITableViewCell {

	@IBOutlet weak var newsImageView: UIImageView!
	@IBOutlet weak var newsTimeLabel: UILabel!
	@IBOutlet weak var newsTitleLabel: UILabel!
	@IBOutlet weak var newsDescriptionLabel: UILabel!
	@IBOutlet weak var cellBackgroundView: UIView!

@IBOutlet weak var newsDescriptionLabelHeightConstraint: NSLayoutConstraint!
@IBOutlet weak var newsDescriptionLabelZeroHeightConstraint: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()
		designUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension NewsCell {

	func updateNewsCell(news: NewsModel) {

		if let newsTitle = news.title {
			newsTitleLabel.text = newsTitle
		} else {
			newsTitleLabel.text = "no title"
		}

		if let newsDescription = news.description {
			newsDescriptionLabel.text = newsDescription
		} else {
			newsDescriptionLabel.text = "no description"
		}

		if let newsTime = news.publishedAt {
			newsTimeLabel.text = newsTime
		} else {
			newsDescriptionLabel.text = "no time"
		}

		DispatchQueue.global(qos: .utility).async {
			if let imageURL = URL(string: news.urlToImage ?? ""), let imageData = try? UIImage(data: Data(contentsOf: imageURL)) {
				DispatchQueue.main.async {
					self.newsImageView.image = imageData
				}
			}
		}
	}
}

extension NewsCell {
	func designUI() {
		cellBackgroundView.clipsToBounds = true
		cellBackgroundView.layer.cornerRadius = 10

		newsImageView.clipsToBounds = true
		newsImageView.layer.cornerRadius = 10
		newsImageView.backgroundColor = .white
	}
}
