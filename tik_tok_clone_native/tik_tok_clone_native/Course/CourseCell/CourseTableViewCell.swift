//
//  CourseTableViewCell.swift
//  tik_tok_clone_native
//
//  Created by Abhishek Biswas on 23/03/24.
//

import UIKit

protocol CourseTableViewCellDelegate {
    func getHeight(size: CGFloat)
    func sendToDetailsFromMainCell(_model: CourseSubModel, title: String)
}



class CourseTableViewCell: UITableViewCell, UITableViewDelegate, UITableViewDataSource, subCourseTableViewCellDelegate {

    static let cellID = "CourseTableViewCell"
    
    @IBOutlet weak var lessonLabel: UILabel!
    @IBOutlet weak var courseImageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var xpLabel: UILabel!
    @IBOutlet weak var hourNeeded: UILabel!
    
    var delegate : CourseTableViewCellDelegate?
    var _subCourseArray : [CourseSubModel] = []
    var titleMain : String?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(subCourseTableViewCell.nib(), forCellReuseIdentifier: subCourseTableViewCell.cellID)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "CourseTableViewCell", bundle: nil)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _subCourseArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: subCourseTableViewCell.cellID, for: indexPath) as? subCourseTableViewCell
        cell?.subCourseLabel.text = self._subCourseArray[indexPath.row].title
        cell?.subCourseImageView.image = UIImage.init(systemName: "doc.plaintext.fill")
        cell?.delegate = self
        cell?._subModel = self._subCourseArray[indexPath.row]
        return cell ?? UITableViewCell()
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
    }

    func getTableViewHeight() {
        delegate?.getHeight(size: self.tableView.contentSize.width)
    }
    
    func goToDetails(_model: CourseSubModel) {
        self.delegate?.sendToDetailsFromMainCell(_model: _model, title: self.titleMain ?? "")
    }
}


