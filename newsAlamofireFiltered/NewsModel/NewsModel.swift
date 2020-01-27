//
//  NewsModel.swift
//  newsAlamofireFiltered
//
//  Created by Mykhailo Tsyba on 1/27/20.
//  Copyright © 2020 miketsyba. All rights reserved.
//

import Foundation
import UIKit

class NewsModel {
	var source: String?
	var articles: [String: Any]?
	var author: String?
	var title: String?
	var description: String?
	var url: String?
	var urlToImage: String?
	var publishedAt: String?
	var newsImage: UIImage?
}
