//
//  PhoneAuthController.swift
//  tik_tok_clone_native
//
//  Created by Abhishek Biswas on 21/03/24.
//

import UIKit


class PhoneAuthController : UIViewController {
    
    @IBOutlet weak var messagelabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var resendBtn: UIButton!
    @IBOutlet weak var verifyBtn: UIButton!
    @IBOutlet weak var phoneCodeBtn: UILabel!
    @IBOutlet weak var otpView: UIView!
    @IBOutlet weak var phoneTxtField: UITextField!
    @IBOutlet weak var optViewFull: UIView!
    @IBOutlet weak var sendCodeBtn: UIButton!
    @IBOutlet weak var phoneCodeView: UIView!
    @IBOutlet weak var phoneNumberView: UIView!
    @IBOutlet weak var tickBtn: UIView!
    
    var isOtpRecived : Bool = false
    var otpString : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareForPhoneAuthScreen()
    }
    
    
    private func prepareForPhoneAuthScreen() {
        self.optViewFull.isHidden = true
        self.verifyBtn.layer.cornerRadius = 15
        self.sendCodeBtn.layer.cornerRadius = 15
        self.phoneCodeView.layer.borderWidth = 0.66
        self.phoneCodeView.layer.borderColor = UIColor.white.cgColor
        self.phoneNumberView.layer.borderWidth = 0.66
        self.phoneNumberView.layer.borderColor = UIColor.white.cgColor
        self.phoneCodeView.layer.cornerRadius = 15
        self.phoneNumberView.layer.cornerRadius = 15
        self.phoneTxtField.backgroundColor = UIColor.clear
        self.phoneCodeView.backgroundColor = UIColor.black.withAlphaComponent(0.12)
        self.phoneNumberView.backgroundColor = UIColor.black.withAlphaComponent(0.12)
        self.backButton.addTarget(self, action: #selector(backAction(_ :)), for: .touchUpInside)
        self.sendCodeBtn.addTarget(self, action: #selector(sendCodeAction(_ :)), for: .touchUpInside)
        self.verifyBtn.addTarget(self, action: #selector(verifyCodeAction(_ :)), for: .touchUpInside)
        self.sendCodeBtn.setTitle("Send Code", for: .normal)
        self.verifyBtn.setTitle("Verify Code", for: .normal)
        self.backButton.setTitleColor(UIColor.white, for: .normal)
//        self.tickBtn.layer.cornerRadius = 5
//        self.tickBtn.layer.borderColor = UIColor.white.cgColor
//        self.tickBtn.layer.borderWidth = 1.0
    }
    
    
    @objc func backAction(_ sender : UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @objc func sendCodeAction(_ sender: UIButton) {
        guard let phoneNumTXT = self.phoneTxtField.text else {return}
        if (!phoneNumTXT.isEmpty){
            AuthController.shared.preparePhoneNumberVerify(controller: self, phoneNumber: phoneNumTXT) { (otpString) in
                if let resultString = otpString {
                    self.otpString = resultString
                    DispatchQueue.main.async {
                        self.isOtpRecived = true
                        self.optViewFull.isHidden = false
                    }
                }else{
                    DispatchQueue.main.async {
                        ConstResource.makeAlert(title: "Error", message: "Failed to send OTP", controller: self)
                    }
                }
            }
        }else{
            ConstResource.makeAlert(title: "Error", message: "Phone Number Cannot Empty", controller: self)
        }
    }
    
    
    @objc func verifyCodeAction(_ sender: UIButton){
        AuthController.shared.verifyOtpPhoneVerify(controller: self, otpString: self.otpString) { result in
            if let _authModel = result {
                print(_authModel.username)
            }else{
                DispatchQueue.main.async {
                    ConstResource.makeAlert(title: "Error", message: "Failed to Verify OTP", controller: self)
                }
            }
        }
    }
}
