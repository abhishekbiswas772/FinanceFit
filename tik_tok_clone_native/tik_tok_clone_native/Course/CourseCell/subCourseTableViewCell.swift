//
//  subCourseTableViewCell.swift
//  tik_tok_clone_native
//
//  Created by Abhishek Biswas on 24/03/24.
//

import UIKit

protocol subCourseTableViewCellDelegate {
    func goToDetails(_model: CourseSubModel)
}

class subCourseTableViewCell: UITableViewCell {
    
    @IBOutlet weak var subCourseImageView: UIImageView!
    @IBOutlet weak var subCourseLabel: UILabel!
    @IBOutlet weak var startBtn: UIButton!
    
    var delegate : subCourseTableViewCellDelegate?
    var _subModel : CourseSubModel?
    
    static let cellID = "subCourseTableViewCell"
    static func nib() -> UINib {
        return UINib(nibName: "subCourseTableViewCell", bundle: nil)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.startBtn.addTarget(self, action: #selector(startBtnAction(_ :)), for: .touchUpInside)
        self.startBtn.layer.cornerRadius = 5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    @objc func startBtnAction(_ sender: UIButton){
        if let courseSubModel = _subModel {
            delegate?.goToDetails(_model: courseSubModel)
        }
    }
    
}
