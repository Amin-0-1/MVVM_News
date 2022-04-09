//
//  LastTime.swift
//  MVVM_News
//
//  Created by Sulfah on 08/04/2022.
//

import Foundation
import RealmSwift
class LastHitTime:Object{
    @Persisted var category : String?
    @Persisted var time:Date?
}
