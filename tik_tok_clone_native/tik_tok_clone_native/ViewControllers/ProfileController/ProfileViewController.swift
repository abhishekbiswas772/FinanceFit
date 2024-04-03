//
//  ProfileViewController.swift
//  tik_tok_clone_native
//
//  Created by Abhishek Biswas on 23/03/24.
//

import UIKit
import SnackBar_swift
import Kingfisher

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var inviteView: UIView!
    @IBOutlet weak var inviteBtn: UIButton!
    @IBOutlet weak var referalCodeLabel: UILabel!
    @IBOutlet weak var copyBtn: UIButton!
    @IBOutlet weak var styleImageView: UIImageView!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var labelUsername: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var settingsBtn: UIButton!
    @IBOutlet weak var inviewReferView: UIView!
    
    
    var _authModel : AuthModel?
    var username : String?
    var mail : String?
    var referCode : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.prepareForViewSetup()
        self.title = "Profile"
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 22),
            NSAttributedString.Key.foregroundColor: UIColor.white
        ]
    }
    
    func prepareForViewSetup() {
        self.getDataFromUsrDefaults()
        self.username = _authModel?.username
        self.mail = _authModel?.email
        self.referCode = _authModel?.referalCode
        self.mainView.clipsToBounds = true
        self.mainView.layer.cornerRadius = 25
        self.mainView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        self.inviteView.layer.cornerRadius = 20
        self.inviteBtn.layer.cornerRadius = 15
        self.inviewReferView.layer.cornerRadius = 13
        self.settingsBtn.addTarget(self, action: #selector(settingAction(_ :)), for: .touchUpInside)
        self.inviteBtn.addTarget(self, action: #selector(inviteBtnAction(_ :)), for: .touchUpInside)
        if (mail == nil || ((mail?.isEmpty) != nil)){
            self.emailLabel.text = "Email Not Exits as User is anonymous"
        }
        self.labelUsername.text = username ?? ""
        self.emailLabel.text = mail ?? ""
        self.referalCodeLabel.text = referCode?.uppercased() ?? ""
        if let username = username, let pPhoto = _authModel?.profilePhoto {
            if pPhoto != "" {
                if let url = URL(string: _authModel?.profilePhoto ?? "") {
                    self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width / 2
                    self.profileImageView.kf.setImage(with: url)
                }
            }else {
                self.profileImageView.setImageWith(username, color: UIColor.black, circular: true)
            }
        } else {
            self.profileImageView.setImageWith(username, color: UIColor.black, circular: true)
        }
        self.copyBtn.addTarget(self, action: #selector(copyBtnAction(_ :)), for: .touchUpInside)
    }
    
    
    func getDataFromUsrDefaults() {
        if let _authModelRealm = AuthModel.getAuthFromRealm() {
            self._authModel = _authModelRealm
        }
    }
    
    @objc func inviteBtnAction(_ sender: UIButton){
        let inviteVC = UIStoryboard(name: "HomeStoryBoard", bundle: nil).instantiateViewController(withIdentifier: "InviteViewController") as? InviteViewController
        inviteVC?.referCode = _authModel?.referalCode
        if let presentationController = inviteVC?.presentationController as? UISheetPresentationController {
            presentationController.detents = [.custom(resolver: { context in
                return 500
            })]
        }
        self.present(inviteVC ?? UIViewController(), animated: true, completion: nil)
    }
    
    @objc func copyBtnAction(_ sender : UIButton){
        UIPasteboard.general.string = _authModel?.referalCode ?? ""
        SnackBar.make(in: self.view, message: "Copied the Referal Code \(_authModel?.referalCode ?? "")", duration: .lengthLong).show()
    }
    
    
    @objc func settingAction(_ sender: UIButton) {
        let settingVC = UIStoryboard(name: "HomeStoryBoard", bundle: nil).instantiateViewController(withIdentifier: "SettingsViewController") as? SettingsViewController
        settingVC?._authModel = self._authModel
        self.navigationController?.pushViewController(settingVC ?? UIViewController(), animated: true)
    }
}

