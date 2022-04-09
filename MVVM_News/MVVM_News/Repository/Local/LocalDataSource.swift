//
//  MyRealm.swift
//  MVVM_News
//
//  Created by Sulfah on 08/04/2022.
//

import Foundation
import RealmSwift
import RxRelay
import RxSwift

protocol MyRealmInterface:Datasource{
    func saveNewsItems(items:[Article])
    func getLastHitTime()->Observable<Date?>
    var country:BehaviorRelay<String>{get set}
    var category:BehaviorRelay<String>{get}
    var allData:PublishSubject<[Article]>{get}
    var saveLastTime:PublishSubject<Void>{get set}
}

class LocalDataSource:MyRealmInterface{
    var saveLastTime: PublishSubject<Void>
    
    var allData: PublishSubject<[Article]>
    
    var country: BehaviorRelay<String>
    
    var category: BehaviorRelay<String>
    

    private let realm = try! Realm()
    private var bag:DisposeBag
    
    init(){
        
        country = BehaviorRelay(value: "")
        category = BehaviorRelay(value: "")
        allData = PublishSubject()
        saveLastTime = PublishSubject()
        bag = DisposeBag()
        bind()
    }

    private func bind(){
        saveLastTime.bind{[weak self] _ in
            guard let self = self else {return}
            if let cat = UDKeys(rawValue: self.category.value){
                MyUserDefaults.set(value: Date(), forKey: cat )
            }
        }.disposed(by: bag)
    }
    func getLastHitTime() -> Observable<Date?> {
        guard let cat = UDKeys(rawValue: category.value) else {return Observable.just(nil)}

        guard let date = MyUserDefaults.getValue(forKey: cat) as? Date else {return Observable.just(nil)}
        return Observable.just(date)
        
    }
    func fetch() {
        let hits = realm.objects(NewsItemModel.self).where{$0.category == category.value}
        var items = [Article]()
        hits.forEach { item in
            
            let article = item.mapToArticles()
            
            items.append(article)
        }
        
        allData.onNext(items)
        
    }
    func saveNewsItems(items:[Article]){
        var objs = [NewsItemModel]()
        items.forEach { article in
            let obj = NewsItemModel()
            article.mapToRealm(obj: obj)
            obj.category = self.category.value
            objs.append(obj)
        }
        try! realm.write {
            realm.add(objs)
        }
    }
}
