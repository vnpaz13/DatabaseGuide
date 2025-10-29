//
//  SignInView.swift
//  Project
//
//  Created by VnPaz on 3/10/25.
//

import UIKit
import RealmSwift


class SignInView: UIViewController {
    
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var pwTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    
    private var id: String? {
        didSet {
            print("id가 입력되었습니다: \(id ?? "없음")")
        }
    }
    
    func userIdDetect(_ updatedText: String) {
        id = updatedText
    }
    
    // Password
    private var password: String? {
        didSet {
            print("pw가 입력되었습니다: \(password ?? "없음")")
        }
    }
    
    func userPwDetect(_ updatedText: String) {
        password = updatedText
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadBackButton()
        keyboardDismissGesture()

    }
    
    let userInfo = UserInfo()
    let realm = try! Realm()
    
    @IBAction func signInTapped(_ sender: UIButton) {
        
        id = idTextField.text
        password = pwTextField.text
        
        
        guard let currentId : String = id,
              let currentPassword : String = password else {
            print(#file, #function, #line, "no id or password")
            return
        }
        
        userInfo.userID = id ?? ""
        userInfo.userPW = password ?? ""

        // 로컬db에 저장된 PersonalInfo를 다 가져와라
        // 입력된 id, password와 일치하는 애들만 필터링하기
        let storedUsers : Results<UserInfo> = realm.objects(UserInfo.self)
            .where{$0.userID == currentId && $0.userPW == currentPassword }
        
        // 찾은애들중에 가장 첫번째
        // 찾은 사용자 정보가 옵셔널이다
        let storedUser : UserInfo? = storedUsers.first
        
        
        // 로그인이 성공하면 - 데이터가 있다
        if storedUser != nil {
            // 다음 화면으로 넘어감
            goToNextPage()
        } else { // 로그인이 실패하면 - 데이터가 없다
            // 경고알림을 보여준다
            showAlert(message: "계정 정보가 일치하지 않습니다, 다시 확인해주세요")
        }
        
        if checkIfLoggedIn(currentId: currentId, currentPassword: currentPassword) {
            goToNextPage()
        } else {
            print("계정 정보가 일치하지 않습니다.")
            showAlert(message: "계정 정보가 일치하지 않습니다, 다시 확인해주세요")
        }
        
        func checkIfLoggedIn(currentId: String, currentPassword: String) -> Bool {
            let value : UserInfo? = realm.objects(UserInfo.self)
               .where{$0.userID == currentId && $0.userPW == currentPassword }.first
            return value != nil
        }
        
        
        func goToNextPage() {
            let nextVC = storyboard?.instantiateViewController(withIdentifier: "MainViewController") as! MainView
            navigationController?.pushViewController(nextVC, animated: false)
        }
        
        func showAlert(message: String) {
            let alert = UIAlertController(title: "로그인 실패", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default))
            present(alert, animated: true)
        }
        
    }
    
    
}
