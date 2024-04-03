//
//  RatingViewController.swift
//  tik_tok_clone_native
//
//  Created by Abhishek Biswas on 26/03/24.
//

import UIKit
import Cosmos

class RatingViewController: UIViewController {
    
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var ratingView: CosmosView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.ratingView.rating = 0
        self.cancelBtn.addTarget(self, action: #selector(_cancelAction(_ :)), for: .touchUpInside)
        self.ratingView.settings.starSize = 30
        self.ratingView.settings.filledColor = UIColor.orange
        self.ratingView.didFinishTouchingCosmos = { rating in
            print(rating)
        }
        self.ratingView.didTouchCosmos = { rating in
            print(rating)
        }
    }
    
    
    @objc func _cancelAction(_ sender : UIButton){
        self.dismiss(animated: true, completion: nil)
    }

}
