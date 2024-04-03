//
//  CourseViewController.swift
//  tik_tok_clone_native
//
//  Created by Abhishek Biswas on 23/03/24.
//

import UIKit
import ProgressHUD

class CourseViewController: UIViewController, CourseTableViewCellDelegate {

    @IBOutlet weak var tableView : UITableView!
    @IBOutlet weak var secondView: UIView!
    @IBOutlet weak var pointsBtn: UIBarButtonItem!
    @IBOutlet weak var takeFinalBtn: UIButton!
    
    var _courseModelGlobal : [CourseModel] = []
    var isSelected : Bool = false
    var selectedIndex : Int?
    var heightSubTable : CGFloat = 0.0

    override func viewDidLoad() {
        super.viewDidLoad()
        self.makeCourseAPICall()
        self.takeFinalBtn.isHidden = true
        self.title = "Learn, Earn and Play"
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 22),
            NSAttributedString.Key.foregroundColor: UIColor.white
        ]
        self.secondView.clipsToBounds = true
        self.secondView.layer.cornerRadius = 25
        self.secondView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.takeFinalBtn.layer.cornerRadius = 15
        self.pointsBtn.target = self
        self.pointsBtn.action = #selector(_pointsAction(_ :))
        self.takeFinalBtn.addTarget(self, action: #selector(takeQuizAction(_ :)), for: .touchUpInside)
        self.tableView.register(CourseTableViewCell.nib(), forCellReuseIdentifier: CourseTableViewCell.cellID)
    }
    
    @objc func takeQuizAction(_ sender: UIButton){
        let quizVC = UIStoryboard(name: "HomeStoryBoard", bundle: nil).instantiateViewController(withIdentifier: "QuizViewController") as? QuizViewController
        self.navigationController?.pushViewController(quizVC ?? UIViewController(), animated: true)
    }
    
    
    @objc func _pointsAction(_ sender: UIButton) {
        let pointsVC = UIStoryboard(name: "HomeStoryBoard", bundle: nil).instantiateViewController(withIdentifier: "PointsViewController") as? PointsViewController
        if let presentationController = pointsVC?.presentationController as? UISheetPresentationController {
            presentationController.detents = [.custom(resolver: { context in
                return 250
            })]
        }
        if let _authModel = AuthModel.getAuthFromRealm() {
            pointsVC?.totalPoints = "\(_authModel.previousPoints ?? 0)"
        }
        self.present(pointsVC ?? UIViewController(), animated: true, completion: nil)
    }
    
    
    func makeCourseAPICall(){
        ProgressHUD.animate()
        ProgressHUD.animationType = .barSweepToggle
        CourseController.shared.isRealmContainsOrAPIHit { result in
            if let result = result {
                DispatchQueue.main.async {
                    ProgressHUD.remove()
                    self.takeFinalBtn.isHidden = false
                    self._courseModelGlobal = result
                    self.tableView.reloadData()
                }
            }
        }
    }
}


extension CourseViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _courseModelGlobal.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let courseCell = tableView.dequeueReusableCell(withIdentifier: CourseTableViewCell.cellID, for: indexPath) as? CourseTableViewCell
        courseCell?.lessonLabel.text = _courseModelGlobal[indexPath.row].title
        courseCell?._subCourseArray = _courseModelGlobal[indexPath.row].subChapters
        courseCell?.xpLabel.text = "\(_courseModelGlobal[indexPath.row].points)"
        courseCell?.hourNeeded.text = _courseModelGlobal[indexPath.row].time_to_complete
        courseCell?.courseImageView.image = UIImage.init(systemName: "play.square.fill")
        courseCell?.delegate = self
        return courseCell ?? UITableViewCell()
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        let currentCell = tableView.cellForRow(at: indexPath) as? CourseTableViewCell
        currentCell?.getTableViewHeight()
        if isSelected {
            isSelected = false
        }else {
            isSelected = true
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if isSelected {
            return 80 + self.heightSubTable
        }else {
            return UITableView.automaticDimension
        }
    }
    
    func getHeight(size: CGFloat) {
        self.heightSubTable = size
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func sendToDetailsFromMainCell(_model: CourseSubModel, title : String) {
        DispatchQueue.main.async {
            let detailsVC = UIStoryboard(name: "HomeStoryBoard", bundle: nil).instantiateViewController(withIdentifier: "CourseDetailsViewController") as? CourseDetailsViewController
            detailsVC?._modelSubCourse = _model
            self.navigationController?.pushViewController(detailsVC ?? UIViewController(), animated: true)
        }
    }
}
