//
//  ViewController.swift
//  tik_tok_clone_native
//
//  Created by Abhishek Biswas on 18/03/24.
//

import UIKit
import ProgressHUD

class ViewController: UIViewController {
    
    @IBOutlet weak var loginImageView: UIImageView!
    @IBOutlet weak var exploreButton: UIButton!
    @IBOutlet weak var faceBookBtnLogin: UIButton!
    @IBOutlet weak var googleBtnLogin: UIButton!
    @IBOutlet weak var phoneNumberLogin: UIButton!
    @IBOutlet weak var loginBtnScreen: UIButton!
    @IBOutlet weak var ppBtn: UIButton!
    @IBOutlet weak var tandCBtn: UIButton!
    
    var otpCode : String = ""
    var isOtpResponseCame : Bool = false
    
    private func prepareforSetupSignUp() {
        self.exploreButton.layer.cornerRadius = 15
        self.faceBookBtnLogin.layer.cornerRadius = 15
        self.googleBtnLogin.layer.cornerRadius = 15
        self.phoneNumberLogin.layer.cornerRadius = 15
        self.loginImageView.image = UIImage.gifImageWithName("Business chart")
        self.googleBtnLogin.addTarget(self, action: #selector(googleBtnLoginAction(_ :)), for: .touchUpInside)
        self.phoneNumberLogin.addTarget(self, action: #selector(phoneActionBtn(_ :)), for: .touchUpInside)
        self.exploreButton.addTarget(self, action: #selector(exploreButtonAction(_ :)), for: .touchUpInside)
    }
    
    @objc func googleBtnLoginAction(_ sender : UIButton){
        ProgressHUD.animate()
        ProgressHUD.animationType = .barSweepToggle
        AuthController.shared.googleSignFunctionlity(controller: self) { model in
            if let _ = model {
                DispatchQueue.main.async {
                    ProgressHUD.remove()
                    let vc = UIStoryboard(name: "HomeStoryBoard", bundle: nil).instantiateViewController(withIdentifier: "TapViewController") as? TapViewController
                    vc?.modalPresentationStyle = .fullScreen
                    self.present(vc ?? UIViewController(), animated: true, completion: nil)
                }
                
            }else{
                ProgressHUD.remove()
                DispatchQueue.main.async {
                    ConstResource.makeAlert(title: "Error!", message: "Failed to login", controller: self)
                }
            }
        }
    }
    
    
    @objc func exploreButtonAction(_ sender: UIButton){
        ProgressHUD.animate()
        ProgressHUD.animationType = .barSweepToggle
        AuthController.shared.signInWithOutMailAndSSO { result in
            DispatchQueue.main.async {
                ProgressHUD.remove()
                if let _ = result {
                    DispatchQueue.main.async {
                        let vc = UIStoryboard(name: "HomeStoryBoard", bundle: nil).instantiateViewController(withIdentifier: "TapViewController") as? TapViewController
                        vc?.modalPresentationStyle = .fullScreen
                        self.present(vc ?? UIViewController(), animated: true, completion: nil)
                    }
                
                }else{
                    ConstResource.makeAlert(title: "Error", message: "Failed To Start!!", controller: self)
                }
            }
        }
    }
    
    
    @objc func phoneActionBtn(_ sender: UIViewController){
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PhoneAuthController") as? PhoneAuthController
        vc?.modalPresentationStyle = .fullScreen
        self.present(vc ?? UIViewController(), animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.prepareforSetupSignUp()
    }
    
    
    
    
    



}

