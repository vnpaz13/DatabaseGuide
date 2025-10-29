//
//  UserInfo.swift
//  Project
//
//  Created by VnPaz on 3/12/25.
//

import UIKit
import RealmSwift

// signUp : userName, userGender, userNN, userID, userPW
// signIn : userID, userPW

class UserInfo: Object {
    
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var userName: String = ""
    @Persisted var userGender: String = ""
    @Persisted var userNN: String = ""
    @Persisted var userID: String = ""
    @Persisted var userPW: String = ""
    
    convenience init(userName: String, userGender: String, userNN: String, userID: String, userPW: String) {
        self.init()
        self.userName = userName
        self.userGender = userGender
        self.userNN = userNN
        self.userID = userID
        self.userPW = userPW
    }
    
}
