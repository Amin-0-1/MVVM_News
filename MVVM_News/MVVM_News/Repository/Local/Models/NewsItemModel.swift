//
//  NewsItemModel.swift
//  MVVM_News
//
//  Created by Sulfah on 08/04/2022.
//

import Foundation
import RealmSwift
class NewsItemModel:Object{
    @Persisted var title : String?
    @Persisted var author : String?
    @Persisted var desc : String?
    @Persisted var url:String?
    @Persisted var imageURL:String?
    @Persisted var publishedAt:String?
    @Persisted var source:NewsItemSource?
    @Persisted var category:String?
    
    func mapToArticles()->Article{
 
        let source = Source(id: self.source?.id , name: self.source?.name ?? "")
        
        return  Article(source: source, author: self.author, title: self.title ?? "", articleDescription: self.desc, url: self.imageURL ?? "", urlToImage: self.imageURL, publishedAt: self.publishedAt ?? "", content: nil)
//        return
    }
}

class NewsItemSource:Object{
    @Persisted var name:String?
    @Persisted var id:String?
}
