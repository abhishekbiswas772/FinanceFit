//
//  PointsViewController.swift
//  tik_tok_clone_native
//
//  Created by Abhishek Biswas on 26/03/24.
//

import UIKit

class PointsViewController: UIViewController {
    
    
    @IBOutlet weak var pointsView: UIView!
    @IBOutlet weak var pointsLabel: UILabel!
    @IBOutlet weak var backBtn: UIButton!
    
    var totalPoints : String?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.backBtn.addTarget(self, action: #selector(_backAction(_ :)), for: .touchUpInside)
        self.pointsView.layer.cornerRadius = 15
        self.pointsLabel.text = self.totalPoints ?? ""
    }
    
    
    @objc func _backAction(_ sender: UIButton){
        self.dismiss(animated: true, completion: nil)
    }

}
