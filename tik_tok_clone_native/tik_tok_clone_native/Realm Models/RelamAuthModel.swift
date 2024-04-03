//
//  RelamAuthModel.swift
//  tik_tok_clone_native
//
//  Created by Abhishek Biswas on 26/03/24.
//

import Foundation
import RealmSwift


class RealmAuthModel : Object{
    @Persisted(primaryKey: true) var _id : ObjectId
    @Persisted var username : String
    @Persisted var email : String
    @Persisted var uid : String
    @Persisted var profilePhoto : String
    @Persisted var phoneNumber : String
    @Persisted var previousPoints : Int
    @Persisted var isAnanomous : Bool
    @Persisted var referalCode : String
    
    
    convenience init(username: String, email: String, uid: String, profilePhoto: String, phoneNumber: String, previousPoints: Int, isAnanomous: Bool, referalCode: String) {
        self.init()
        self.username = username
        self.email = email
        self.uid = uid
        self.profilePhoto = profilePhoto
        self.phoneNumber = phoneNumber
        self.previousPoints = previousPoints
        self.isAnanomous = isAnanomous
        self.referalCode = referalCode
    }
}





