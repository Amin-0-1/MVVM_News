//
//  NewsModel.swift
//  MVVM_News
//
//  Created by Sulfah on 08/04/2022.
//


import Foundation
// MARK: - RemoteInterface
struct NewsModel: Codable {
    let status: String
    let totalResults: Int
    let articles: [Article]
}

// MARK: - Article
struct Article: Codable {
    let source: Source
    let author: String?
    let title: String
    let articleDescription: String?
    let url: String
    let urlToImage: String?
    let publishedAt: String
    let content: String?

    enum CodingKeys: String, CodingKey {
        case source, author, title
        case articleDescription = "description"
        case url, urlToImage, publishedAt, content
    }
    
    func mapToRealm(obj:NewsItemModel){
        obj.url = self.url
        obj.title = self.title
        obj.author = self.author
        obj.desc = self.articleDescription
        obj.imageURL = self.urlToImage
        obj.publishedAt = self.publishedAt
        obj.content = self.content
        let source = NewsItemSource()
        source.id = self.source.id
        source.name = self.source.name
        
        obj.source = source
    }

}

// MARK: - Source
struct Source: Codable {
    let id: String?
    let name: String
}
