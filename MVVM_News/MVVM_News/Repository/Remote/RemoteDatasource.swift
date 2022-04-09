//
//  Remote.swift
//  MVVM_News
//
//  Created by Sulfah on 08/04/2022.
//

import Foundation
import Moya
import RxSwift
import RxRelay

protocol RemoteInterface:Datasource{
    var country:BehaviorRelay<String>{get set}
    var category:BehaviorRelay<String>{get set}
    var articles: PublishSubject<[Article]>{get set}
    
}

class RemoteDatasource:RemoteInterface{
    
    var country: BehaviorRelay<String>
    
    var category: BehaviorRelay<String>
    
    var articles: PublishSubject<[Article]>

    
    private var remoteApi:MoyaProvider<NewsTargets>!
    private var bag:DisposeBag
    init(){
        remoteApi = MoyaProvider<NewsTargets>(plugins:[NetworkLoggerPlugin()])
        articles = PublishSubject()
        category = BehaviorRelay(value: "")
        country = BehaviorRelay(value: "")
        bag = DisposeBag()
    }
    func fetch() {
        switch category {
        default:
            remoteApi.request(.fetch(category: category.value, country: country.value)) { [weak self] result in
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
