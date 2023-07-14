//
//  SignUpViewController.swift
//  WhatsUp
//
//  Created by Mohamed Elkomey on 09/07/2023.
//

import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

class SignUpViewController: UIViewController {

    @IBOutlet weak var emailTxtField: UITextField!
    @IBOutlet weak var passwordTxtField: UITextField!
    @IBOutlet weak var errorLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTxtField.keyboardType = UIKeyboardType.emailAddress
        // Do any additional setup after loading the view.
    }
    
    @IBAction func signUpPressed(_ sender: UIButton) {
        errorLbl.text = ""
        let email = emailTxtField.text!
        let password = passwordTxtField.text!
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if error == nil{
                print("User Registered Successfully")
                print(authResult?.user.uid)
                self.performSegue(withIdentifier: "signUpToChat", sender: self)
            }else{
                print(error?.localizedDescription)
                self.errorLbl.text = error?.localizedDescription
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
