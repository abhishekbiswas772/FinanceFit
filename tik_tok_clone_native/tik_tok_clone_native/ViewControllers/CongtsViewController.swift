//
//  CongtsViewController.swift
//  tik_tok_clone_native
//
//  Created by Abhishek Biswas on 26/03/24.
//

import UIKit
import PDFGenerator
import ProgressHUD

class CongtsViewController: UIViewController {
    
    @IBOutlet weak var mainView : UIView!
    @IBOutlet weak var certiImageView: UIImageView!
    @IBOutlet weak var savePdfBtn: UIButton!
    @IBOutlet weak var saveImageBtn: UIButton!
    @IBOutlet weak var rateBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Certificate"
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 22),
            NSAttributedString.Key.foregroundColor: UIColor.white
        ]
        self.checkForCertificate()
        self.mainView.clipsToBounds = true
        self.mainView.layer.cornerRadius = 25
        self.certiImageView.layer.cornerRadius = 13
        self.savePdfBtn.layer.cornerRadius = 13
        self.saveImageBtn.layer.cornerRadius = 13
        self.mainView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        self.saveImageBtn.addTarget(self, action: #selector(_saveImageAction(_ :)), for: .touchUpInside)
        self.rateBtn.addTarget(self, action: #selector(_rateAction(_ :)), for: .touchUpInside)
        self.savePdfBtn.addTarget(self, action: #selector(_savePdfBtn(_ :)), for: .touchUpInside)
    }
    
    private func checkForCertificate() {
        if let _authModel = AuthModel.getAuthFromRealm() {
            if let imageData = UserDefaults.standard.value(forKey: _authModel.uid ?? "") as? Data {
                if let image = UIImage(data: imageData) {
                    self.certiImageView.image = image
                }else {
                    self.generateCetificateForAuthUser()
                }
            }else {
                self.generateCetificateForAuthUser()
            }
        }
    }
    
    private func generateCetificateForAuthUser() {
        ProgressHUD.animate()
        ProgressHUD.animationType = .barSweepToggle
        CourseController.shared.getCertificateImage { resultImage in
            if let imageCert = resultImage, let _authUser = AuthModel.getAuthFromRealm() {
                UserDefaults.standard.setValue(imageCert.pngData(), forKey: _authUser.uid ?? "")
                DispatchQueue.main.async{
                    ProgressHUD.remove()
                    self.certiImageView.image = imageCert
                }
            }
        }
    }
    
    
    @objc func _saveImageAction(_ sender: UIButton){
        let alert : UIAlertController = UIAlertController(title: "Alert!!", message: "Do you want to save this certificate image in photo library", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ok", style: .default, handler: { action in
            if let cetificateImage = self.certiImageView.image {
                UIImageWriteToSavedPhotosAlbum(cetificateImage, self, #selector(self.image(_:didFinishSavingWithError:contextInfo:)), nil)
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func _rateAction(_ sender: UIButton) {
        let rateVC = UIStoryboard(name: "HomeStoryBoard", bundle: nil).instantiateViewController(withIdentifier: "RatingViewController") as? RatingViewController
        if let presentationController = rateVC?.presentationController as? UISheetPresentationController {
            presentationController.detents = [.custom(resolver: { context in
                return 250
            })]
        }
        self.present(rateVC ?? UIViewController(), animated: true, completion: nil)
    }
    
    @objc func _savePdfBtn(_ sender: UIButton){
        let alert : UIAlertController = UIAlertController(title: "Alert!!", message: "Do you want to save this certificate PDF in Documents", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ok", style: .default, handler: { action in
            do {
                if let cImageView = self.certiImageView.image {
                    let page: [PDFPage] = [
                        .whitePage(CGSize(width: 200.0, height: 100.0)),
                        .image(cImageView),
                        .whitePage(CGSize(width: 200.0, height: 100.0))
                    ]
                    let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                    let path = documentsDirectory.appendingPathComponent("certificate_finance.pdf")
                    try PDFGenerator.generate(page, to: path, password: "")
                }
            } catch let error {
                print(error)
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeMutableRawPointer?) {
        if let error = error {
            print("Error saving image: \(error.localizedDescription)")
        } else {
            print("Image saved successfully")
        }
    }

}
