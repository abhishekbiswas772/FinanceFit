//
//  AuthModel.swift
//  tik_tok_clone_native
//
//  Created by Abhishek Biswas on 18/03/24.
//

import Foundation
import RealmSwift

class AuthModel {
    var username : String?
    var email : String?
    var uid : String?
    var profilePhoto: String?
    var previousPoints: Int?
    var phoneNumber : String?
    var isAnanomous : Bool?
    var referalCode : String?
    
    init(username: String? = nil, email: String? = nil, uid: String? = nil, profilePhoto: String? = nil, previousPoints: Int? = nil, phoneNumber: String? = nil, isAnanomous: Bool? = nil, referalCode: String? = nil) {
        self.username = username
        self.email = email
        self.uid = uid
        self.profilePhoto = profilePhoto
        self.previousPoints = previousPoints
        self.phoneNumber = phoneNumber
        self.isAnanomous = isAnanomous
        self.referalCode = referalCode
    }
    
    
    class func saveAuthToRelam(_model : AuthModel) -> AuthModel? {
        do{
            let realm = try Realm()
            let _realmAuthModel = RealmAuthModel(username: _model.username ?? "", email: _model.email ?? "", uid: _model.uid ?? "", profilePhoto: _model.profilePhoto ?? "", phoneNumber: _model.phoneNumber ?? "", previousPoints: _model.previousPoints ?? 0, isAnanomous: _model.isAnanomous ?? false, referalCode: _model.referalCode ?? "")
            try realm.write {
                realm.add(_realmAuthModel)
            }
            return _model
        }catch(_){
            return nil
        }
    }
    
    class func getAuthFromRealm() -> AuthModel? {
        do{
            let realm = try Realm()
            if let _authRealmModel = realm.objects(RealmAuthModel.self).first {
                let _singleAuthModel : AuthModel = AuthModel(
                    username: _authRealmModel.username,
                    email: _authRealmModel.email,
                    uid: _authRealmModel.uid,
                    profilePhoto: _authRealmModel.profilePhoto,
                    previousPoints: _authRealmModel.previousPoints,
                    phoneNumber: _authRealmModel.phoneNumber,
                    isAnanomous: _authRealmModel.isAnanomous,
                    referalCode: _authRealmModel.referalCode
                )
                return _singleAuthModel
            }
        }catch(_){
            return nil
        }
        return nil
    }
}
