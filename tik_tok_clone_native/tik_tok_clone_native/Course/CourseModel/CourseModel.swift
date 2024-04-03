//
//  CourseModel.swift
//  tik_tok_clone_native
//
//  Created by Abhishek Biswas on 19/03/24.
//

import Foundation
import RealmSwift

class CourseQuizModel {
    var question : String
    var answer : String
    var incorrect_answer1 : String
    var incorrect_answer2 : String
    var isAnswered : Bool
    
    init(question: String, answer: String, incorrect_answer1: String, incorrect_answer2: String, isAnswered: Bool) {
        self.question = question
        self.answer = answer
        self.incorrect_answer1 = incorrect_answer1
        self.incorrect_answer2 = incorrect_answer2
        self.isAnswered = isAnswered
    }
    
    class func parseJsonToClass(_jsonString : [String: Any]) -> [CourseQuizModel]{
        var _modelQuiz : [CourseQuizModel] = []
        if let res = _jsonString["data"] as? [[String : Any]] {
            for itemString in res {
                if let correctAns = itemString["correct_answer"] as? String, let incorrect_answer1 = itemString["incorrect_answer1"] as? String, let incorrect_answer2 = itemString["incorrect_answer2"] as? String, let question = itemString["question"] as? String{
                    let singleCourseQuizModel = CourseQuizModel(question: question, answer: correctAns, incorrect_answer1: incorrect_answer1, incorrect_answer2: incorrect_answer2, isAnswered: false)
                    _modelQuiz.append(singleCourseQuizModel)
                }
            }
        }
        return _modelQuiz
    }
    
    class func saveQuizModelInRelam(_model : [CourseQuizModel]) {
        do{
            let realm = try Realm()
            for item in _model {
                let _rQuizModel = RelamCourseQuizModel(question: item.question, answer: item.answer, incorrect_answer1: item.incorrect_answer1, incorrect_answer2: item.incorrect_answer2, isAnswered: item.isAnswered)
                try realm.write {
                    realm.add(_rQuizModel)
                }
            }
        }catch(let e){
            print(e.localizedDescription as Any)
        }
    }
    
    class func getQuizModelFromRelam() -> [CourseQuizModel]{
        var _modelQuiz : [CourseQuizModel] = []
        do{
            let realm = try Realm()
            let rQuizModels = realm.objects(RelamCourseQuizModel.self)
            for item in rQuizModels {
                let rSingleQuizModel : CourseQuizModel = CourseQuizModel(question: item.question, answer: item.answer, incorrect_answer1: item.incorrect_answer1, incorrect_answer2: item.incorrect_answer2, isAnswered: item.isAnswered)
                _modelQuiz.append(rSingleQuizModel)
            }
        }catch(let e){
            print(e.localizedDescription as Any)
        }
        return _modelQuiz
    }
}


class CourseModel {
    var title : String
    var content : String
    var id : Int
    var points : Int
    var time_to_complete: String
    var subChapters : [CourseSubModel]
    var isCompleted : Bool = false
    
    init(title: String, content: String, id: Int, points: Int, time_to_complete: String, subChapters: [CourseSubModel]) {
        self.title = title
        self.content = content
        self.id = id
        self.points = points
        self.time_to_complete = time_to_complete
        self.subChapters = subChapters
    }
    
    class func parseJsonToClass(_payloadJson : [String: Any]) -> CourseModel? {
        if let title = _payloadJson["title"] as? String, let time_to_complete = _payloadJson["time_to_complete"] as? String, let points = _payloadJson["points"] as? Int, let id = _payloadJson["id"] as? Int, let content = _payloadJson["content"] as? String, let subChapter = _payloadJson["sub_chapters"] as? [[String : Any]] {
            
            var subModel : [CourseSubModel] = []
            for item in subChapter {
                let subItemModel = CourseSubModel.parseJsonToClass(_payloadJson: item)
                if let subCourseItem  = subItemModel {
                    subModel.append(subCourseItem)
                }
            }
            let _courseModel = CourseModel(title: title, content: content, id: id, points: points, time_to_complete: time_to_complete, subChapters: subModel)
            return _courseModel
        }
        return nil
    }
    
    
}


class CourseSubModel {
    var title : String
    var chapter_id: Int
    var id : Int
    var points : Int
    var content : String
    var isCompleted : Bool = false
    
    init(title: String, chapter_id: Int, id: Int, points: Int, content: String) {
        self.title = title
        self.chapter_id = chapter_id
        self.id = id
        self.points = points
        self.content = content
    }
    
    class func parseJsonToClass(_payloadJson : [String: Any]) -> CourseSubModel? {
        if let title = _payloadJson["title"] as? String, let content = _payloadJson["content"] as? String, let chapter_id = _payloadJson["chapter_id"] as? Int, let id = _payloadJson["id"] as? Int, let points = _payloadJson["points"] as? Int {
            let _subModel : CourseSubModel = CourseSubModel(title: title, chapter_id: chapter_id, id: id, points: points, content: content)
            return _subModel
        }
        return nil
    }
}

