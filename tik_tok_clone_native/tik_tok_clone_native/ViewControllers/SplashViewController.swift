//
//  SplashViewController.swift
//  tik_tok_clone_native
//
//  Created by Abhishek Biswas on 21/03/24.
//

import UIKit

class SplashViewController: UIViewController {
    
    @IBOutlet weak var splashImageView : UIImageView!
    
    
    var _authModelGlobal : AuthModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.moveToNextVC()
    }
    
    
    private func checkAuth() -> Bool {
        if let _authModel = AuthModel.getAuthFromRealm() {
            self._authModelGlobal = _authModel
            return true
        }else{
            return false
        }
    }
    
    private func moveToNextVC() -> Void {
        let _isAuthUserPresent = self.checkAuth()
        if(_isAuthUserPresent) {
            if (_authModelGlobal != nil){
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0){
                    DispatchQueue.main.async {
                        let vc = UIStoryboard(name: "HomeStoryBoard", bundle: nil).instantiateViewController(withIdentifier: "TapViewController") as? TapViewController
                        vc?.modalPresentationStyle = .fullScreen
                        self.present(vc ?? UIViewController(), animated: true, completion: nil)
                    }
                }
            }else{
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0){
                    let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ViewController") as? ViewController
                    vc?.modalPresentationStyle = .fullScreen
                    self.present(vc ?? UIViewController(), animated: true)
                }
            }
        }else{
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0){
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ViewController") as? ViewController
                vc?.modalPresentationStyle = .fullScreen
                self.present(vc ?? UIViewController(), animated: true)
            }
        }
    }
}
