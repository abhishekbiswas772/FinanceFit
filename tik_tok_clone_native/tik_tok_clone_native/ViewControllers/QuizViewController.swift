//
//  QuizViewController.swift
//  tik_tok_clone_native
//
//  Created by Abhishek Biswas on 27/03/24.
//

import UIKit
import ProgressHUD

class QuizViewController: UIViewController {
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var ans1Btn: UIButton!
    @IBOutlet weak var ans2Btn: UIButton!
    @IBOutlet weak var ans3Btn: UIButton!
    @IBOutlet weak var nextAndSubmitBtn: UIButton!
    @IBOutlet weak var progressNow: UIProgressView!
    
    var _modelQuiz : [CourseQuizModel] = []
    var tempArray : [String] = []
    var currentIndex : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.progressNow.progress = 0
        self.getQuestionQuiz { result in
            DispatchQueue.main.async {
                ProgressHUD.remove()
                self._modelQuiz = result
                self.questionLabel.text = self._modelQuiz[self.currentIndex].question
                self.makeRandomAnswer()
                self.ans1Btn.layer.cornerRadius = 13
                self.ans2Btn.layer.cornerRadius = 13
                self.ans3Btn.layer.cornerRadius = 13
                self.nextAndSubmitBtn.layer.cornerRadius = 13
                self.ans1Btn.layer.borderColor = UIColor.black.cgColor
                self.ans2Btn.layer.borderColor = UIColor.black.cgColor
                self.ans3Btn.layer.borderColor = UIColor.black.cgColor
                self.ans1Btn.layer.borderWidth = 0.55
                self.ans2Btn.layer.borderWidth = 0.55
                self.ans3Btn.layer.borderWidth = 0.55
                self.ans1Btn.addTarget(self, action: #selector(self.ans1Action(_ :)), for: .touchUpInside)
                self.ans2Btn.addTarget(self, action: #selector(self.ans2Action(_ :)), for: .touchUpInside)
                self.ans3Btn.addTarget(self, action: #selector(self.ans3Action(_ :)), for: .touchUpInside)
                self.nextAndSubmitBtn.addTarget(self, action: #selector(self.nextSubmitAction(_ :)), for: .touchUpInside)
            }
        }
    }
    
    private func getQuestionQuiz(onCallBack: @escaping([CourseQuizModel]) -> Void) {
        ProgressHUD.animate()
        ProgressHUD.animationType = .barSweepToggle
        CourseController.shared.getQuizQuestions { result in
            if let res = result {
                onCallBack(res)
            }
        }
    }
    
    
    @objc func nextSubmitAction(_ sender: UIButton) {
//        if self.currentIndex == (self._modelQuiz.count - 1) {
//            self.nextAndSubmitBtn.setTitle("Get Certificate", for: .normal)
//        }
//        if (self.nextAndSubmitBtn.currentTitle == "Get Certificate"){
//            for item in self._modelQuiz {
//                if item.isAnswered != true {
//                    ConstResource.makeAlert(title: "Alert!!", message: "Compleate Quiz", controller: self)
//                    break
//                }
//            }
//            let certificateVC = UIStoryboard(name: "HomeStoryBoard", bundle: nil).instantiateViewController(withIdentifier: "CongtsViewController") as? CongtsViewController
//            self.navigationController?.pushViewController(certificateVC ?? UIViewController(), animated: true)
//        }
//        if self.currentIndex <= self._modelQuiz.count {
//            self.currentIndex += 1
//            self.makeRandomAnswer()
//            self.progressNow.progress = Float((self._modelQuiz.count) / 10)
//        }
        
        let certificateVC = UIStoryboard(name: "HomeStoryBoard", bundle: nil).instantiateViewController(withIdentifier: "CongtsViewController") as? CongtsViewController
        self.navigationController?.pushViewController(certificateVC ?? UIViewController(), animated: true)
    }
    
    private func makeCustomAlert(callBack: @escaping() -> Void) {
        let alert = UIAlertController(title: "Alert!!", message: "Incorrect Answer, try again", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ok", style: .default, handler: { action in
            callBack()
        }))
        alert.addAction(UIAlertAction(title: "cancel", style: .cancel))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    @objc func ans1Action(_ sender : UIButton){
        if self.ans1Btn.currentTitle == self._modelQuiz[self.currentIndex].answer {
            self.ans1Btn.backgroundColor = UIColor.green.withAlphaComponent(0.4)
        }else{
            self.ans1Btn.backgroundColor = UIColor.red.withAlphaComponent(0.4)
            self.makeCustomAlert {
                DispatchQueue.main.async {
                    self.ans1Btn.backgroundColor = UIColor.clear
                }
            }
        }
    }
    
    @objc func ans2Action(_ sender: UIButton){
        if self.ans2Btn.currentTitle == self._modelQuiz[self.currentIndex].answer {
            self.ans2Btn.backgroundColor = UIColor.green.withAlphaComponent(0.4)
        }else{
            self.ans2Btn.backgroundColor = UIColor.red.withAlphaComponent(0.4)
            self.makeCustomAlert {
                DispatchQueue.main.async {
                    self.ans2Btn.backgroundColor = UIColor.clear
                }
            }
        }
    }
    
    @objc func ans3Action(_ sender : UIButton){
        if self.ans3Btn.currentTitle == self._modelQuiz[self.currentIndex].answer {
            self.ans3Btn.backgroundColor = UIColor.green.withAlphaComponent(0.4)
        }else{
            self.ans3Btn.backgroundColor = UIColor.red.withAlphaComponent(0.4)
            self.makeCustomAlert {
                DispatchQueue.main.async {
                    self.ans3Btn.backgroundColor = UIColor.clear
                }
            }
        }
    }
    
    private func makeRandomAnswer() {
        if self.currentIndex <= (self._modelQuiz.count - 1) {
            self.questionLabel.text = self._modelQuiz[currentIndex].question
            self.tempArray.append(self._modelQuiz[currentIndex].answer)
            self.tempArray.append(self._modelQuiz[currentIndex].incorrect_answer1)
            self.tempArray.append(self._modelQuiz[currentIndex].incorrect_answer2)
            self.tempArray.shuffle()
            self.ans1Btn.setTitle(self.tempArray[0], for: .normal)
            self.ans2Btn.setTitle(self.tempArray[1], for: .normal)
            self.ans3Btn.setTitle(self.tempArray[2], for: .normal)
            self.ans1Btn.backgroundColor = UIColor.clear
            self.ans2Btn.backgroundColor = UIColor.clear
            self.ans3Btn.backgroundColor = UIColor.clear
        }
    }

}
