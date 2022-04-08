//
//  Remote.swift
//  MVVM_News
//
//  Created by Sulfah on 08/04/2022.
//

import Foundation
import Moya
import RxSwift

protocol RemoteInterface{
    func fetch(categories:[Categories],country:String)
    var articles:PublishSubject<[Article]> {get}
}

class Remote:RemoteInterface{
    var articles: PublishSubject<[Article]>
    

    
    private var remoteApi:MoyaProvider<NewsTargets>!
    
    init(){
        remoteApi = MoyaProvider<NewsTargets>(plugins:[NetworkLoggerPlugin()])
        articles = PublishSubject()
    }
    
    func fetch(categories:[Categories], country: String) {
        categories.forEach { category in
            switch category {
            default:
                remoteApi.request(.fetch(category: category, country: country)) { [weak self] result in
                    guard let self = self else {return}
                    switch result{
                    case .failure(let error):
                        print(error)
                    case .success(let response):
                        print(response.data)
                        guard let decodedData = try? JSONDecoder().decode(NewsModel.self, from: response.data) else {fatalError("unable to decode")}
                            self.articles.onNext(decodedData.articles)
                    }
                }
                
            }
        }
    }
    
    
}
