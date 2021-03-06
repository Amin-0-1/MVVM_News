//
//  HomeViewModel.swift
//  MVVM_News
//
//  Created by Sulfah on 08/04/2022.
//

import Foundation
import RxSwift
import RxRelay

protocol HomeViewModelInterface{
    var allNews:BehaviorSubject<[Article]>{get}
    var interests:BehaviorRelay<[String]>{get}
    var selectedInterest:BehaviorRelay<String>{get}
    var searchObserver:PublishSubject<String?>{get set}
    var cancelSearch:PublishSubject<Void>{get}
    var searchList:PublishSubject<[Article]>{get}
    var showLoading:PublishSubject<Void>{get}
    var hideLoading:PublishSubject<Void>{get}
    
}
class HomeViewModel:HomeViewModelInterface{
    var showLoading: PublishSubject<Void>
    
    var hideLoading: PublishSubject<Void>
    
    var searchList: PublishSubject<[Article]>
    
    
    var cancelSearch: PublishSubject<Void>
    
    var searchObserver: PublishSubject<String?>
    
    var selectedInterest: BehaviorRelay<String>
    
    var interests: BehaviorRelay<[String]>
    
    var allNews: BehaviorSubject<[Article]>
    
    
    private var repo:RepoInterface!
    private var country:String
    
    private var categories:[Categories]
    private var bag:DisposeBag!
    init(datasource:RepoInterface){
        self.repo = datasource
        bag = DisposeBag()
        allNews = BehaviorSubject(value: [])
        interests = BehaviorRelay(value: [])
        searchObserver = PublishSubject()
        selectedInterest = BehaviorRelay(value: "")
        cancelSearch = PublishSubject()
        searchList = PublishSubject()
        showLoading = PublishSubject()
        hideLoading = PublishSubject()
        country = ""
        categories = []
        getCountry()
        getInterests()
        bind()
        showLoading.onNext(())
        repo.fetch()
        
    }
    private func getCountry(){
        guard let country = MyUserDefaults.getValue(forKey: .country) as? String else {return}
        self.country = country
        repo.country.accept(country)
    }
    private func getInterests(){
        guard let data = MyUserDefaults.getValue(forKey: .interests) as? Data else {return}
        guard let decodedData = try? JSONDecoder().decode([String].self, from: data) else {return}
        interests.accept(decodedData)
        categories = decodedData.compactMap{Categories(rawValue: $0)}
        selectedInterest.accept(categories[0].rawValue)
    }
    
    private func bind(){

        cancelSearch.bind{[weak self] _ in
            guard let self = self else {return}
            self.showLoading.onNext(())
            self.repo.fetch()
            
        }.disposed(by: bag)
        repo.articles.bind{[weak self] val in
            guard let self = self else {return}
            self.hideLoading.onNext(())
            self.allNews.onNext(val)

        }.disposed(by: bag)
        selectedInterest.bind{ [weak self] category in
            guard let self = self else {return}
            self.repo.category.accept(category)
            self.showLoading.onNext(())
            self.repo.fetch()
        }.disposed(by: bag)
        searchObserver.subscribe{[weak self] text in
            guard let self = self else {return}
            guard let text = text.element else {return}
            guard let text = text else {return}
            if text.isEmpty{
                self.showLoading.onNext(())
                self.repo.fetch()
                
            }else{
                var results = [Article]()
                try? self.allNews.value().forEach { article in
//                    guard let desc = article.articleDescription else {return}
//                    guard let author = article.author else {return}
                    if article.title.contains(text.lowercased()){
                        results.append(article)
                    }
                    
//                    if desc.lowercased().contains(text.lowercased()){
//                        results.append(article)
//                    }
//
//                    if author.lowercased().contains(text.lowercased()){
//                        results.append(article)
//                    }
//
                    
                }
//                    self.searchList.onNext(results)
                self.allNews.onNext(results)
            }
        }.disposed(by: bag)
    }
}
