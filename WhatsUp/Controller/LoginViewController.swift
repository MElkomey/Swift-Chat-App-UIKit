//
//  LoginViewController.swift
//  WhatsUp
//
//  Created by Mohamed Elkomey on 09/07/2023.
//

import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

class LoginViewController: UIViewController ,UITextFieldDelegate{

    @IBOutlet weak var emailTxtField: UITextField!
    @IBOutlet weak var passwordTxtField: UITextField!
    @IBOutlet weak var errorLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTxtField.delegate = self
        passwordTxtField.delegate = self
        emailTxtField.keyboardType = UIKeyboardType.emailAddress
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func loginPressed(_ sender: UIButton) {
        errorLbl.text = ""
        let email = emailTxtField.text!
        let password = passwordTxtField.text!
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
          guard let strongSelf = self else { return }
            if error == nil{
                print("User login succedded" )
                strongSelf.performSegue(withIdentifier: "loginToChat", sender: self)
            }else{
                print(error?.localizedDescription)
                strongSelf.errorLbl.text = error?.localizedDescription
            }
        }
    }

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
