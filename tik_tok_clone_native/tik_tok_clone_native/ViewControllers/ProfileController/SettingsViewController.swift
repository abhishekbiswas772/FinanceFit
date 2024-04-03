//
//  SettingsViewController.swift
//  tik_tok_clone_native
//
//  Created by Abhishek Biswas on 23/03/24.
//

import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var email : UILabel!
    @IBOutlet weak var logoutBtn: UIButton!
    @IBOutlet weak var pImageView: UIImageView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var deleteProfileBtn: UIButton!
    @IBOutlet weak var emailStack: UIStackView!
    @IBOutlet weak var nameView: UIView!
    @IBOutlet weak var mailView: UIView!
    
    var _authModel : AuthModel?
    var username : String?
    var mail : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareForViewSetup()
        self.title = "Settings"
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 22),
            NSAttributedString.Key.foregroundColor: UIColor.white
        ]
    }
    
    func prepareForViewSetup() {
        self.username = _authModel?.username
        self.mail = _authModel?.email
        self.nameLabel.text = username ?? ""
        self.mainView.clipsToBounds = true
        self.mainView.layer.cornerRadius = 25
        self.nameView.layer.cornerRadius = 12
        self.mailView.layer.cornerRadius = 12
        self.nameView.layer.borderColor = UIColor.black.withAlphaComponent(0.15).cgColor
        self.mailView.layer.borderColor = UIColor.black.withAlphaComponent(0.15).cgColor
        self.logoutBtn.addTarget(self, action: #selector(logoutFunc(_ :)), for: .touchUpInside)
        self.nameView.layer.borderWidth = 0.55
        self.mailView.layer.borderWidth = 0.55
        if let mail = mail, !mail.isEmpty{
            self.email.text = mail 
        }else{
            self.email.text = "Email Not Exits as User is anonymous"
        }
        self.mainView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        if let username = username, let pPhoto = _authModel?.profilePhoto {
            if pPhoto != "" {
                if let url = URL(string: _authModel?.profilePhoto ?? "") {
                    self.pImageView.layer.cornerRadius = self.pImageView.frame.size.width / 2
                    self.pImageView.kf.setImage(with: url)
                }
            }else {
                self.pImageView.setImageWith(username, color: UIColor.black, circular: true)
            }
        } else {
            self.pImageView.setImageWith(username, color: UIColor.black, circular: true)
        }
    }
    
    @objc func logoutFunc(_ sender: UIButton) {
        let resultFromFirebase = AuthController.shared.prepareForSignOut()
        if resultFromFirebase {
            self.navigationController?.popToRootViewController(animated: true)
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ViewController") as? ViewController
            vc?.modalPresentationStyle = .fullScreen
            self.present(vc ?? UIViewController(), animated: true, completion: nil)
        }else {
            ConstResource.makeAlert(title: "Error", message: "Failed to Signout", controller: self)
        }
    }
}
