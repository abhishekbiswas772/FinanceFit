//
//  RelamCourseQuizModel.swift
//  tik_tok_clone_native
//
//  Created by Abhishek Biswas on 27/03/24.
//

import Foundation
import RealmSwift

class RelamCourseQuizModel : Object {
    @Persisted(primaryKey: true) var _id : ObjectId
    @Persisted var question : String
    @Persisted var answer : String
    @Persisted var incorrect_answer1 : String
    @Persisted var incorrect_answer2 : String
    @Persisted var isAnswered : Bool
    
    convenience init(question: String, answer: String, incorrect_answer1: String, incorrect_answer2: String, isAnswered : Bool) {
        self.init()
        self.question = question
        self.answer = answer
        self.incorrect_answer1 = incorrect_answer1
        self.incorrect_answer2 = incorrect_answer2
        self.isAnswered = isAnswered
    }
}

