//
//  CourseDetailsViewController.swift
//  tik_tok_clone_native
//
//  Created by Abhishek Biswas on 24/03/24.
//

import UIKit
import RealmSwift

class CourseDetailsViewController: UIViewController {
    @IBOutlet weak var markedAsRead: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailsLabel: UITextView!
    @IBOutlet weak var mainView: UIView!
    
    var _modelSubCourse : CourseSubModel?
    var titleStr: String?
    var details: String?
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.detailsLabel.isEditable = false
        self.mainView.clipsToBounds = true
        self.mainView.layer.cornerRadius = 25
        self.mainView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        self.titleStr = _modelSubCourse?.title ?? ""
        self.details = _modelSubCourse?.content ?? ""
        self.markedAsRead.layer.cornerRadius = 15
        if let title = self.titleStr, let details = self.details {
            self.titleLabel.text = title
            self.detailsLabel.text = details
        }
        self.markedAsRead.addTarget(self, action: #selector(_markedActionRead(_ :)), for: .touchUpInside)
    }
    
    
    @objc func _markedActionRead(_ sender: UIButton){
        if let isComplted = self._modelSubCourse?.isCompleted {
            if isComplted == true {
                if let model = self._modelSubCourse {
                    self.updateCourseObjectInRealm(model)
                    self.updatePointsInAuth(model)
                    self.navigationController?.popViewController(animated: true)
                }else {
                    ConstResource.makeAlert(title: "Alert!!", message: "This Chapter Already marked as read", controller: self)
                }
            }else{
                ConstResource.makeAlert(title: "Error", message: "Some Error Happened", controller: self)
            }
        }
    }
    
    
    private func updateCourseObjectInRealm(_ model: CourseSubModel) {
        do {
            let realm = try Realm()
            let courseSubObjectRealm = realm.objects(RealmSubCourseModel.self)
            for item in courseSubObjectRealm {
                if item.msId == model.id && item.chapter_id == model.chapter_id {
                    try realm.write {
                        item.isCompleted = true
                    }
                }
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    
    
    private func updatePointsInAuth(_ model: CourseSubModel) {
        if let _authModel = AuthModel.getAuthFromRealm() {
            _authModel.previousPoints = (_authModel.previousPoints ?? 0) + model.points
            do{
                let realm = try Realm()
                if let _rAuthModel = realm.objects(RealmAuthModel.self).first {
                    try realm.write {
                        _rAuthModel.previousPoints = (_authModel.previousPoints ?? 0) + model.points
                    }
                }
            }catch(let e){
                print(e.localizedDescription as Any)
            }
        }
    }
}
