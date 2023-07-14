//
//  ChatViewController.swift
//  WhatsUp
//
//  Created by Mohamed Elkomey on 10/07/2023.
//

import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

class ChatViewController: UIViewController {
    
    var messages = [Message]()
    var db = Firestore.firestore()

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.separatorStyle = .none
        
        messageTextField.delegate = self
        
        tableView.register(UINib(nibName: "SenderTableViewCell", bundle: nil), forCellReuseIdentifier: "senderMessageCell")
        tableView.register(UINib(nibName: "RecieverTableViewCell", bundle: nil), forCellReuseIdentifier: "recieverMessageCell")

        navigationItem.setHidesBackButton(true, animated: true)
        
        readMessagesFromServer()
    }
    
    @IBAction func logOutPressed(_ sender: UIBarButtonItem) {
        let firebaseAuth = Auth.auth()
        do {
          try firebaseAuth.signOut()
            self.navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
          print("Error signing out: %@", signOutError)
        }
    }
    
    @IBAction func sendMessagePressed(_ sender: UIButton) {
        var message = Message(sender: Auth.auth().currentUser?.email, body: "")
        message.body = messageTextField.text!
        if message.body != ""{
            postMessageToServer(message)
            //messages.append(message)
            //tableView.reloadData()
            messageTextField.text = ""
        }
    }

    func postMessageToServer(_ message:Message){
        // Add a new document with a generated id.
        var ref: DocumentReference? = nil
        ref = db.collection("messages").addDocument(data: [
            "sender": message.sender!,
            "body": message.body!,
            "time":Date().timeIntervalSince1970 //number of seconds since 1970
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
            }
        }
    }
    
    func readMessagesFromServer(){
        db.collection("messages").order(by: "time").addSnapshotListener{ querySnapshot, error in
                guard let documents = querySnapshot?.documents else {
                    print("Error fetching documents: \(error!)")
                    return
                }
//                let msgs = documents.map { $0["body"]! }
//                print("Current messages in CA: \(msgs)")
            self.messages.removeAll()
            for doc in documents{
                let msgBody = doc.data()["body"] as! String
                let msgSender = doc.data()["sender"] as! String
                self.messages.append(Message(sender: msgSender, body: msgBody))
            }
            self.tableView.reloadData()
            let indexPath = IndexPath(row: self.messages.count-1, section: 0)
            if indexPath.row>5{
                self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
            }
            }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

}

extension ChatViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if Auth.auth().currentUser?.email == messages[indexPath.row].sender{
            let cell = tableView.dequeueReusableCell(withIdentifier: "senderMessageCell", for: indexPath) as! SenderTableViewCell
            cell.senderMessgaeLabel.text = messages[indexPath.row].body
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "recieverMessageCell", for: indexPath) as! RecieverTableViewCell
            cell.recieverMessageLbl.text = messages[indexPath.row].body
            return cell
        }

    }
}

extension ChatViewController:UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        var message = Message(sender: Auth.auth().currentUser?.email, body: "")
        message.body = messageTextField.text!
        if message.body != ""{
            postMessageToServer(message)
            //messages.append(message)
            //tableView.reloadData()
            messageTextField.text = ""
        }
        return true
    }

}
