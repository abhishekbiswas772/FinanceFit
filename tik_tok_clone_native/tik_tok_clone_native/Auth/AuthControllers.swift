//
//  AuthControllers.swift
//  tik_tok_clone_native
//
//  Created by Abhishek Biswas on 18/03/24.
//

import FirebaseCore
import FirebaseAuth
import UIKit
import GoogleSignIn
import RealmSwift


class AuthController {
    static let shared = AuthController()
    
    func googleSignFunctionlity(controller: UIViewController, compleationCallback: @escaping(AuthModel?) ->  Void) {
        guard let clientId = FirebaseApp.app()?.options.clientID else {
            compleationCallback(nil)
            return
        }
        let config = GIDConfiguration(clientID: clientId)
        GIDSignIn.sharedInstance.configuration = config
        GIDSignIn.sharedInstance.signIn(withPresenting: controller) {[weak self] (result, error) in
            guard let self = self else {
                compleationCallback(nil)
                return
            }
            if error != nil {
                compleationCallback(nil)
            }else if let data = result {
                let user = data.user
                let gidToken = user.idToken?.tokenString
                let credential = GoogleAuthProvider.credential(withIDToken: gidToken ?? "", accessToken: user.accessToken.tokenString)
                createUserInFirebaseAndLocal(cred: credential){(_authModel) in
                    guard let model = _authModel else {
                        compleationCallback(nil)
                        return
                    }
                    compleationCallback(model)
                }
            }
        }
    }
    
    func prepareForSignOut() -> Bool{
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            let resFromRealm = self.removeAuthFromRealm()
            let resFromCourseRealm = self.removeCourseAndSubCourseFromRealm()
            if resFromRealm && resFromCourseRealm{
                return true
            }else {
                return false
            }
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
            return false
        }
    }
    
    
    private func removeCourseAndSubCourseFromRealm() -> Bool {
        do{
           let realm = try Realm()
            let allRealmCourseObjects = realm.objects(RealmCourseModel.self)
            for courseItem in allRealmCourseObjects {
                try realm.write {
                    realm.delete(courseItem)
                }
            }
            let allSubRealmCourseObject = realm.objects(RealmSubCourseModel.self)
            for subCourseItem in allSubRealmCourseObject {
                try realm.write {
                    realm.delete(subCourseItem)
                }
            }
            return true
        }catch(let e){
            print(e.localizedDescription as Any)
            return false
        }
    }
    
    
    private func removeAuthFromRealm() -> Bool {
        do{
            let realm = try Realm()
            if let _realmAuthModel = realm.objects(RealmAuthModel.self).first {
                UserDefaults.standard.removeObject(forKey: _realmAuthModel.uid)
                try realm.write {
                    realm.delete(_realmAuthModel)
                }
                return true
            }else {
                return false
            }
        }catch(_){
            return false
        }
    }
    
    private func createUserInFirebaseAndLocal(cred : AuthCredential, compleation: @escaping(AuthModel?) -> Void) {
        Auth.auth().signIn(with: cred) { (result, error) in
            if error != nil {
                compleation(nil)
            }else if let data = result {
                let profilePhoto = data.user.photoURL?.absoluteString
                let username = data.user.displayName
                let email = data.user.email
                let uid = data.user.uid
                let referalCode : String = ConstResource.generateReferralCode()
                let _authModel : AuthModel = AuthModel(username: username, email: email, uid: uid, profilePhoto: profilePhoto, previousPoints: 0, phoneNumber: "", isAnanomous: false, referalCode: referalCode)
                if let _authModelRealm = AuthModel.saveAuthToRelam(_model: _authModel) {
                    compleation(_authModelRealm)
                }else{
                    compleation(nil)
                }
            }
        }
    }
    
    
    
    func preparePhoneNumberVerify(controller: UIViewController, phoneNumber: String, compleation: @escaping(String?) -> Void) {
        if (!phoneNumber.isEmpty && phoneNumber.count == 10){
            Auth.auth().languageCode = "en"
            PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { (result, error) in
                if error != nil {
                    print(error?.localizedDescription as Any)
                    compleation(nil)
                }else if let data = result{
                    compleation(data)
                }
            }
        }else{
            ConstResource.makeAlert(title: "Error", message: "Phone Number Verification Failed", controller: controller)
        }
    }
    
    
    func verifyOtpPhoneVerify(controller: UIViewController, otpString: String, compleation: @escaping(AuthModel?) -> Void) {

        
    }
    
    
    func signInWithOutMailAndSSO(compleation: @escaping(AuthModel?) -> Void) -> Void {
        Auth.auth().signInAnonymously { (result, error) in
            if error != nil {
                print(error?.localizedDescription as Any)
                compleation(nil)
            }else if let data = result {
                let uid = data.user.uid
                let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                let displayRandomName = ConstResource.generateRandomUsername()
                changeRequest?.displayName = displayRandomName
                let referalCode : String = ConstResource.generateReferralCode()
                let _model : AuthModel = AuthModel(username: displayRandomName, email: "", uid: uid, profilePhoto: "", previousPoints: 0, phoneNumber: "", isAnanomous: true, referalCode: referalCode)
                if let _authModelRealm = AuthModel.saveAuthToRelam(_model: _model) {
                    compleation(_authModelRealm)
                }else{
                    compleation(nil)
                }
            }
        }
    }
    
    
//    func signInWithGitHub(controller: UIViewController, compleation: @escaping(AuthModel?) -> Void){
//        var provider = OAuthProvider(providerID: "github.com")
//        provider.customParameters = [
//            "allow_signup": "false"
//        ]
//        provider.scopes = ["user:email"]
//        provider.getCredentialWith(nil) { result, error in
//
//        }
//        
//    }
}

