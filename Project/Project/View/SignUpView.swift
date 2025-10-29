//
//  SignUpView.swift
//  Project
//
//  Created by VnPaz on 3/10/25.
//

import UIKit
import RealmSwift

class SignUpView: UIViewController {

    // 이름 입력 칸
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var maleCheckButton: UIButton!
    @IBOutlet weak var femaleCheckButton: UIButton!
    @IBOutlet weak var nonBinaryButton: UIButton!
    
    
    @IBOutlet weak var nickNameTextField: UITextField!
    @IBOutlet weak var checkNN: UIButton!
    
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var pwTextField: UITextField!
    @IBOutlet weak var checkID: UIButton!
    @IBOutlet weak var checkPW: UIButton!
    
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
// MARK: - 키보드 tool bar
    @IBOutlet var nextToolBar: UIToolbar!
    @IBOutlet var finishToolBar: UIToolbar!
    
// MARK: - 닉네임, ID 중복버튼
    private var isNickNameChecked = false
    private var isIDChecked = false
    private var lastCheckedNickName :String?
    private var lastCheckedID : String?
    
    

// MARK: - 사용자 이름 받아오기
    private var userName: String? {
        didSet {
            print("이름이 입력되었습니다: \(userName ?? "없음")")
        }
    }
    
    private func userNameDetect(_ updatedText: String) {
        userName = updatedText
    }
    
// MARK: - 사용자 성별 받아오기
    
    private var userGender: String? {
        didSet {
            print("성별이 선택되었습니다: \(userGender ?? "없음")")
        }
    }
    
// MARK: - 사용자 닉네임 받아오기
    private var userNN: String? {
        didSet {
            print("닉네임이 입력되었습니다: \(userNN ?? "없음")")
        }
    }
    
    private func userNNDetect(_ updatedText: String) {
        userNN = updatedText
    }
    
// MARK: - 사용자 ID 받아오기
    private var userID: String? {
        didSet {
            print("ID가 입력되었습니다: \(userID ?? "없음")")
        }
    }
    
    private func userIDDetect(_ updatedText: String) {
        userID = updatedText
    }

// MARK: - 사용자 PW 받아오기
    private var userPW: String? {
        didSet {
            print("ID가 입력되었습니다: \(userPW ?? "없음")")
        }
    }
    
    private func userPWDetect(_ updatedText: String) {
        userPW = updatedText
    }

// MARK: - 회원등록 버튼 레이아웃 변경
    private func updateSignUpButtonLayout() {
        guard isNickNameChecked && isIDChecked else {
                    signUpButton.isEnabled = false
                    signUpButton.backgroundColor = UIColor(named: "D2D2D2") ?? UIColor(red: 210/255, green: 210/255, blue: 210/255, alpha: 1.0)
                    return
        }
                
        let isPasswordValid = (pwTextField.text?.count ?? 0) >= 8
                
        let isAllFilled = !(nameTextField.text?.isEmpty ?? true) &&
                          !(nickNameTextField.text?.isEmpty ?? true) &&
                          !(idTextField.text?.isEmpty ?? true) &&
                          isPasswordValid &&
                          (userGender != nil)

        if isAllFilled {
            signUpButton.isEnabled = true
            signUpButton.backgroundColor = UIColor(named: "2358E1") ?? UIColor(red: 35/255, green: 88/255, blue: 225/255, alpha: 1.0)
         } else {
            signUpButton.isEnabled = false
            signUpButton.backgroundColor = UIColor(named: "D2D2D2") ?? UIColor(red: 210/255, green: 210/255, blue: 210/255, alpha: 1.0)
         }
            
    }
    
    
// MARK: - 처음 로딩 화면

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadBackButton()
        keyboardDismissGesture()
        
        signUpButtonLayout()
        textFieldAutoLayout()
        
        // 비밀번호 입력 감지
        pwTextField.addTarget(self, action: #selector(pwTextFieldDidChange(_:)), for: .editingChanged)
        
        // 초기 버튼 UI 설정
        maleCheckButton.isSelected = false
        femaleCheckButton.isSelected = false
        nonBinaryButton.isSelected = false

        // 버튼 스타일 적용
        updateGenderButtonUI()
        
        nameTextField.inputAccessoryView = nextToolBar
        nickNameTextField.inputAccessoryView = nextToolBar
        idTextField.inputAccessoryView = nextToolBar
        pwTextField.inputAccessoryView = finishToolBar
    }
    
    let userInfo = UserInfo()
    
    let realm = try! Realm()
    
    
// MARK: -  성별 버튼

    @IBAction func genderButtonTapped(_ sender: UIButton) {
        
        maleCheckButton.isSelected = false
        femaleCheckButton.isSelected = false
        nonBinaryButton.isSelected = false
        
        sender.isSelected = true
        
        // 선택된 성별 저장
        switch sender {
        case maleCheckButton:
            userGender = "Male"
        case femaleCheckButton:
            userGender = "Female"
        case nonBinaryButton:
            userGender = "Non-Binary"
        default:
            userGender = nil
        }

        print("선택된 성별: \(userGender ?? "없음")")
        
        updateGenderButtonUI()
    }
    
    private func updateGenderButtonUI() {
        let selectedImage = UIImage(systemName: "checkmark.square.fill") // 선택된 상태
        let defaultImage = UIImage(systemName: "checkmark.square") // 기본 상태

        // 버튼의 이미지 업데이트
        maleCheckButton.setImage(maleCheckButton.isSelected ? selectedImage : defaultImage, for: .normal)
        femaleCheckButton.setImage(femaleCheckButton.isSelected ? selectedImage : defaultImage, for: .normal)
        nonBinaryButton.setImage(nonBinaryButton.isSelected ? selectedImage : defaultImage, for: .normal)

        // 선택된 버튼만 초록색으로 설정
        maleCheckButton.tintColor = maleCheckButton.isSelected ? .green : .gray
        femaleCheckButton.tintColor = femaleCheckButton.isSelected ? .green : .gray
        nonBinaryButton.tintColor = nonBinaryButton.isSelected ? .green : .gray
    }
    
    
    
// MARK: - 닉네임 중복 버튼

    @IBAction func checkNNTapped(_ sender: UIButton) {
        guard let nickName = nickNameTextField.text, !nickName.isEmpty else {
                   showErrorAlert(message: "닉네임을 입력하세요.")
                   return
            }
       
        let storedUser = realm.objects(UserInfo.self).where { $0.userNN == nickName }.first
                
            if storedUser == nil {
                showAlert(message: "사용 가능한 닉네임입니다!")
                isNickNameChecked = true
                lastCheckedNickName = nickName
            } else {
                showErrorAlert(message: "중복된 닉네임입니다! 다시 확인해주세요.")
                isNickNameChecked = false
            }
            checkBothValidations()
    }
    
// MARK: - ID 중복 버튼

    @IBAction func checkIDTapped(_ sender: Any) {
        guard let userID = idTextField.text, !userID.isEmpty else {
                   showErrorAlert(message: "ID를 입력하세요.")
                   return
               }
               
               let storedUser = realm.objects(UserInfo.self).where { $0.userID == userID }.first
               
               if storedUser == nil {
                   showAlert(message: "사용 가능한 ID입니다!")
                   isIDChecked = true
                   lastCheckedID = userID
               } else {
                   showErrorAlert(message: "중복된 ID입니다! 다시 확인해주세요.")
                   isIDChecked = false
               }
               checkBothValidations()
    }
    
// MARK: - 중복 버튼 2번 무조건 통과해야함
    private func checkBothValidations() {
            if isNickNameChecked && isIDChecked {
                updateSignUpButtonLayout()
            }
        }

    
// MARK: - PW 확인 버튼

    @IBAction func checkPWTapped(_ sender: UIButton) {
        pwTextField.isSecureTextEntry.toggle()
    }
    
    
// MARK: - 회원 등록 버튼

    @IBAction func signUpTapped(_ sender: UIButton) {
        guard let userName = nameTextField.text, !userName.isEmpty,
              let userNN = nickNameTextField.text, !userNN.isEmpty,
              let userID = idTextField.text, !userID.isEmpty,
              let userPW = pwTextField.text, !userPW.isEmpty,
              let userGender = userGender else {
            print("모든 필드를 입력하세요.")
            return
        }
        
        let newUser = UserInfo(userName: userName, userGender: userGender, userNN: userNN, userID: userID, userPW: userPW)
        
        // supbase register
        Task {
            do {
                // SupabaseManager.shared.register
                try await SupabaseManager.shared.register(email: userID, password: userPW, nickName: userNN, gender: userGender)
            } catch(let error) {
                print(#file, #function, #line, "Error ",error)
            }
          
        }
        
        
        // Realm 데이터 저장
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(newUser)
            }
            showAlert(message: "계정이 성공적으로 생성되었습니다! 로그인 해주세요.")
        } catch {
            showErrorAlert(message: "데이터 저장 중 오류가 발생했습니다.")
        }
    }
    
    
// MARK: - Alert 메시지
    func showAlert(message: String) {
        let alert = UIAlertController(title: "회원가입 성공", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
        
    func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "회원가입 실패", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }

// MARK: - 키보드 설정

    @IBAction func handleNextTapped(_ sender: UIBarButtonItem) {
        
        if nameTextField.isFirstResponder {
            nickNameTextField.becomeFirstResponder()
        } else if nickNameTextField.isFirstResponder {
            idTextField.becomeFirstResponder()
        } else if idTextField.isFirstResponder {
            pwTextField.becomeFirstResponder()
                
            // 스크롤 밑으로 내리기
        let bottomOffset = CGPoint(x: 0, y: scrollView.contentSize.height - scrollView.bounds.height + scrollView.contentInset.bottom)
            scrollView.setContentOffset(bottomOffset, animated: true)
        }
    }
    
    @IBAction func handleFinishTapped(_ sender: UIBarButtonItem) {
        pwTextField.resignFirstResponder()
    }
    
    
    // 비밀번호 입력 실시간 감지
    @objc private func pwTextFieldDidChange(_ textField: UITextField) {
        if let text = textField.text, text.count >= 8 {
            updateSignUpButtonLayout()
        }
    }


// MARK: -  TextField 초기 설정

    private func textFieldAutoLayout() {
        // 이름 입력
        nameTextField.placeholder = "이름을 입력하세요"
        nameTextField.textColor = UIColor.infoTextColor
        nameTextField.backgroundColor = UIColor.textFieldBackground
        nameTextField.delegate = self
        
        // 닉네임 입력
        nickNameTextField.placeholder = "닉네임을 입력해주세요 (최대 8자)"
        nickNameTextField.textColor = UIColor.infoTextColor
        nickNameTextField.backgroundColor = UIColor.textFieldBackground
        nickNameTextField.delegate = self
        
        // ID 입력
        idTextField.placeholder = "ID를 입력해주세요"
        idTextField.textColor = UIColor.infoTextColor
        idTextField.backgroundColor = UIColor.textFieldBackground
        idTextField.delegate = self
        
        // 비밀번호 입력
        pwTextField.placeholder = "비밀번호 8~15자리를 입력하세요"
        pwTextField.textColor = UIColor.infoTextColor
        pwTextField.backgroundColor = UIColor.textFieldBackground
        pwTextField.delegate = self
    }
    
    // MARK: - 비밀번호 가리기
    @objc private func pwSecureMode() {
        pwTextField.isSecureTextEntry.toggle()
    }

    
// MARK: - 초기 회원등록 버튼 레이아웃
    private func signUpButtonLayout() {
        signUpButton.backgroundColor = UIColor(named: "D2D2D2") ?? UIColor(red: 210/255, green: 210/255, blue: 210/255, alpha: 1.0)
        signUpButton.setTitle("로그인", for: .normal)
        signUpButton.setTitleColor(.white, for: .normal)
        signUpButton.layer.masksToBounds = true
        signUpButton.layer.cornerRadius = 8
        signUpButton.isEnabled = false
    }

    
    
}


// MARK: - textField 제약

extension SignUpView: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == nameTextField {
            nameTextField.text = ""
            nameTextField.textColor = UIColor.black
        }
        
        if textField == nickNameTextField {
            nickNameTextField.text = ""
            nickNameTextField.textColor = UIColor.black
        }
        
        if textField == idTextField {
            idTextField.text = ""
            idTextField.textColor = UIColor.black
        }
        
        if textField == pwTextField {
            pwTextField.text = ""
            pwTextField.textColor = UIColor.black
            pwTextField.isSecureTextEntry = true
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == nameTextField {
            if nameTextField.text?.isEmpty ?? true {
                nameTextField.placeholder = "이름을 입력하세요"
                nameTextField.textColor = UIColor.infoTextColor
            }
        }
        
        if textField == nickNameTextField {
            if nickNameTextField.text?.isEmpty ?? true {
                nickNameTextField.placeholder = "닉네임 8자리를 정해주세요"
                nickNameTextField.textColor = UIColor.infoTextColor
            }
        }
        
        if textField == idTextField {
            if idTextField.text?.isEmpty ?? true {
                idTextField.placeholder = "ID를 입력해주세요"
                idTextField.textColor = UIColor.infoTextColor
            }
        }
        
        if textField == pwTextField {
            if pwTextField.text?.isEmpty ?? true {
                pwTextField.placeholder = "비밀번호를 입력해주세요"
                pwTextField.text = ""
                
            }
        }
        
        updateSignUpButtonLayout()
    }
    
    // MARK: - 각각의 텍스트 필드의 제약 만들기
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        
        if textField == nickNameTextField {
            let currentText = textField.text ?? ""
            let updatedText = (currentText as NSString).replacingCharacters(in: range, with: string)
//            if updatedText.count > 8 {
//                return false
//            }
            return updatedText.count <= 8
        }
        
        if textField == pwTextField {
            let currentText = textField.text ?? ""
            let updatedText = (currentText as NSString).replacingCharacters(in: range, with: string)
            return updatedText.count <= 15 // 비밀번호 최대 15자 제한
        }
        
        return true
    }
}

// MARK: - 글꼴
extension UIColor {
    
    // 입력칸 배경 색상
    static var textFieldBackground : UIColor {
        return UIColor(named: "EEEFF1") ?? UIColor(red: 238/255, green: 239/255, blue: 241/255, alpha: 1.0)
    }
    
    // 입력칸 글씨 색상 *** 검은색으로 수정 필요 ***
    static var textFieldTextColor : UIColor {
        return UIColor(named: "696B72") ?? UIColor(red: 105/255, green: 107/255, blue: 114/255, alpha: 1.0)
    }
    
    // 입력칸 안내문구 색상
    static var infoTextColor : UIColor {
        return UIColor(named: "BABCBF") ?? UIColor(red: 186/255, green: 188/255, blue: 191/255, alpha: 1.0)
    }
    
    
}

