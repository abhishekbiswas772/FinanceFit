//
//  CourseController.swift
//  tik_tok_clone_native
//
//  Created by Abhishek Biswas on 23/03/24.
//

import Foundation
import UIKit
import RealmSwift

class CourseController {
    static let shared = CourseController()
    
    private func getAllCourse(onCallBack: @escaping ([String: Any]?) -> Void) {
        let chapterUrl: String = ConstResource.getChapterURI()
        guard let url_chapter = URL(string: chapterUrl) else {
            onCallBack(nil)
            return
        }
        
        var request = URLRequest(url: url_chapter)
        request.httpMethod = "GET"
        
        let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
                onCallBack(nil)
            } else if let data = data {
                do {
                    if let decodedResult = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        onCallBack(decodedResult)
                    } else {
                        onCallBack(nil)
                    }
                } catch {
                    print("Error decoding JSON: \(error)")
                    onCallBack(nil)
                }
            }
        }
        dataTask.resume()
    }
    
    private func saveCourseToRealm(_model: [CourseModel]) {
        do{
            let realm = try Realm()
            for item in _model {
                let _realmCourseModel = RealmCourseModel(title: item.title, content: item.content, msID: item.id, points: item.points, time_to_complete: item.time_to_complete, isCompleted: item.isCompleted)
                self.saveSubCourseToRealm(subModel: item.subChapters)
                try realm.write {
                    realm.add(_realmCourseModel)
                }
            }
        }catch(let e){
            print(e.localizedDescription as Any)
        }
    }
    
    private func saveSubCourseToRealm(subModel : [CourseSubModel]) -> Void {
        do{
            let realm = try Realm()
            for subItem in subModel {
                let singleItem : RealmSubCourseModel = RealmSubCourseModel(title: subItem.title, chapter_id: subItem.chapter_id, msId: subItem.id, points: subItem.points, content: subItem.content, isCompleted: subItem.isCompleted)
                try realm.write {
                    realm.add(singleItem)
                }
            }
        }catch(let e){
            print(e.localizedDescription as Any)
        }
    }
    
    private func makeCourseAPICallSaveRealm(_onCallBack: @escaping([CourseModel]?) -> Void){
        CourseController.shared.getAllCourse { result in
            if let result = result {
                if let data = result["data"] as? [[String : Any]] {
                    var _courseModel : [CourseModel] = []
                    for item in data {
                        let singleCourseModel = CourseModel.parseJsonToClass(_payloadJson: item)
                        if let model = singleCourseModel {
                            _courseModel.append(model)
                        }
                    }
                    self.saveCourseToRealm(_model: _courseModel)
                    _onCallBack(_courseModel)
                }else{
                    _onCallBack(nil)
                }
            }else{
                _onCallBack(nil)
            }
        }
    }
    
    public func isRealmContainsOrAPIHit(_onCallBack: @escaping([CourseModel]?) -> Void){
        do{
            let realm = try Realm()
            let realmCourseModel = realm.objects(RealmCourseModel.self)
            if !realmCourseModel.isEmpty && realmCourseModel.count != 0 {
                var _itemChapter : [CourseModel] = []
                for itemChapter in realmCourseModel {
                    var _subItemChapters : [CourseSubModel] = []
                    let realSubCourseModel = realm.objects(RealmSubCourseModel.self)
                    if !realSubCourseModel.isEmpty && realSubCourseModel.count != 0 {
                        for subItem in realSubCourseModel {
                            if itemChapter.msID == subItem.chapter_id {
                                var singleSubModel : CourseSubModel = CourseSubModel(title: subItem.title, chapter_id: subItem.chapter_id, id: subItem.msId, points: subItem.points, content: subItem.content)
                                singleSubModel.isCompleted = subItem.isCompleted
                                _subItemChapters.append(singleSubModel)
                            }
                        }
                    }
                    var rSingleCourseModel = CourseModel(title: itemChapter.title, content: itemChapter.content, id: itemChapter.msID, points: itemChapter.points, time_to_complete: itemChapter.time_to_complete, subChapters: _subItemChapters)
                    rSingleCourseModel.isCompleted = itemChapter.isCompleted
                    _itemChapter.append(rSingleCourseModel)
                }
                _onCallBack(_itemChapter)
            }else {
                self.makeCourseAPICallSaveRealm { result in
                    if let resModel = result {
                        _onCallBack(resModel)
                    }else{
                        _onCallBack(nil)
                    }
                }
            }
        }catch(let e){
            print(e.localizedDescription as Any)
            _onCallBack(nil)
        }
    }
    
    public func getCertificateImage(onCallBack: @escaping(UIImage?) -> Void){
        let final_url : String = ConstResource.getCertificateURI()
        guard let url = URL(string: final_url) else {
            onCallBack(nil)
            return
        }
        var urlRequest : URLRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        let dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let httpResponse = response as? HTTPURLResponse  {
                let statusCode = httpResponse.statusCode
                if statusCode == 201 {
                    if let _ = error {
                        onCallBack(nil)
                    }else if let data  = data{
                        do{
                            if let decodedResult = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                                if let data = decodedResult["data"] as? [String : Any] {
                                    if let base64URL = data["base64_url"] as? String {
                                        guard let imageData = Data(base64Encoded: base64URL) else {
                                            onCallBack(nil)
                                            return
                                        }
                                        guard let image = UIImage(data: imageData) else {
                                            onCallBack(nil)
                                            return
                                        }
                                        onCallBack(image)
                                    }
                                }
                            } else {
                                onCallBack(nil)
                            }
                            
                        }catch{
                            onCallBack(nil)
                        }
                    }
                }else{
                    onCallBack(nil)
                }
            }
        }
        dataTask.resume()
    }
    
    
    private func getQuizAndSaveRealm(onCallBack: @escaping([CourseQuizModel]?) -> Void) {
        let quizUrl = ConstResource.getQuizURI()
        guard let url = URL(string: quizUrl) else {
            onCallBack(nil)
            return
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        let dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let _ = error {
                onCallBack(nil)
            }else if let data = data {
                do{
                    if let decodedResult = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        var _quizModel : [CourseQuizModel] = CourseQuizModel.parseJsonToClass(_jsonString: decodedResult)
                        CourseQuizModel.saveQuizModelInRelam(_model: _quizModel)
                        onCallBack(_quizModel)
                        
                    }
                }catch{
                    onCallBack(nil)
                }
            }
        }
        dataTask.resume()
    }
    
    public func getQuizQuestions(onCallBack: @escaping([CourseQuizModel]?) -> Void){
        let courseQuizModel = CourseQuizModel.getQuizModelFromRelam()
        if courseQuizModel.count != 0 {
            onCallBack(courseQuizModel)
        }else{
            self.getQuizAndSaveRealm { result in
                if let res = result {
                    onCallBack(res)
                }else{
                    onCallBack(nil)
                }
            }
        }
    }
}

