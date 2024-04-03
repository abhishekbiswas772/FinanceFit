//
//  RealmCourseModel.swift
//  tik_tok_clone_native
//
//  Created by Abhishek Biswas on 26/03/24.
//

import Foundation
import RealmSwift

class RealmCourseModel : Object {
    @Persisted(primaryKey: true) var _id : ObjectId
    @Persisted var title : String
    @Persisted var content : String
    @Persisted var msID : Int
    @Persisted var points : Int
    @Persisted var time_to_complete : String
    @Persisted var isCompleted : Bool
    
    convenience init(title: String, content: String, msID: Int, points: Int, time_to_complete: String, isCompleted: Bool) {
        self.init()
        self.title = title
        self.content = content
        self.msID = msID
        self.points = points
        self.time_to_complete = time_to_complete
        self.isCompleted = isCompleted
    }
}

class RealmSubCourseModel : Object {
    @Persisted(primaryKey: true) var _id : ObjectId
    @Persisted var title : String
    @Persisted var chapter_id : Int
    @Persisted var msId : Int
    @Persisted var points : Int
    @Persisted var content : String
    @Persisted var isCompleted : Bool
    
    convenience init(title: String, chapter_id: Int, msId: Int, points: Int, content: String, isCompleted: Bool) {
        self.init()
        self.title = title
        self.chapter_id = chapter_id
        self.msId = msId
        self.points = points
        self.content = content
        self.isCompleted = isCompleted
    }
    
}
    
