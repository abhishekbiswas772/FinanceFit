//
//  InviteViewController.swift
//  tik_tok_clone_native
//
//  Created by Abhishek Biswas on 23/03/24.
//

import UIKit
import SnackBar_swift

class InviteViewController: UIViewController {
    
    @IBOutlet weak var inviteView: UIView!
    @IBOutlet weak var inviteBtn: UIButton!
    @IBOutlet weak var referLabel: UILabel!
    @IBOutlet weak var copyBtn: UIButton!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var referStack: UIView!
    
    var referCode : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.inviteView.clipsToBounds = true
        self.inviteView.layer.cornerRadius = 25
        self.referStack.layer.cornerRadius = 13
        self.inviteView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        self.referLabel.text = self.referCode ?? ""
        self.backBtn.addTarget(self, action: #selector(backBtnAction(_ :)), for: .touchUpInside)
        self.inviteBtn.layer.cornerRadius = 15
        self.copyBtn.addTarget(self, action: #selector(copyActionBtn(_ :)), for: .touchUpInside)
        self.inviteBtn.addTarget(self, action: #selector(shareActionBtn(_ :)), for: .touchUpInside)
    }
    
    @objc func backBtnAction(_ sender: UIButton){
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func copyActionBtn(_ sender: UIButton){
        UIPasteboard.general.string = referCode ?? ""
        SnackBar.make(in: self.view, message: "Copied the Referal Code \(referCode ?? "")", duration: .lengthLong).show()
    }
    
    @objc func shareActionBtn(_ sender: UIButton){
        let firstActivityItem = "Hay I have discovered this amazing app called Money Lessons that teaches you about financial literacy in a fun and interactive way. I think you'd love it!, Download it from App Store use my referal code \(referCode ?? "") to unlock bonus content. Let's become financial whizzes together!"
        let activityViewController : UIActivityViewController = UIActivityViewController(
            activityItems: [firstActivityItem], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = sender
        activityViewController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.down
        activityViewController.popoverPresentationController?.sourceRect = CGRect(x: 150, y: 150, width: 0, height: 0)
        activityViewController.activityItemsConfiguration = [
            UIActivity.ActivityType.message
        ] as? UIActivityItemsConfigurationReading
        activityViewController.excludedActivityTypes = [
            UIActivity.ActivityType.postToWeibo,
            UIActivity.ActivityType.print,
            UIActivity.ActivityType.assignToContact,
            UIActivity.ActivityType.saveToCameraRoll,
            UIActivity.ActivityType.addToReadingList,
            UIActivity.ActivityType.postToFlickr,
            UIActivity.ActivityType.postToVimeo,
            UIActivity.ActivityType.postToTencentWeibo,
            UIActivity.ActivityType.postToFacebook
        ]
        activityViewController.isModalInPresentation = true
        self.present(activityViewController, animated: true, completion: nil)
    }
}
