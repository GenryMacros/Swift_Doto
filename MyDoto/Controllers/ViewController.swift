//
//  ViewController.swift
//  MyDoto
//
//  Created by Bohdan Bushko on 21/11/2021.
//

import UIKit
import Alamofire

struct User {
    var username: String?;
}
class EnterUsernameController : UIViewController {
    var mainController:ViewController? = nil
    var speaker: ApiSpeaker?;
    var login: String = "";
    var pass: String = "";
    @IBOutlet var username: UITextField!
    
    @IBOutlet var password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        speaker = ApiSpeaker()
    }
    
    @IBSegueAction func toChannelsList(_ coder: NSCoder) -> tableViewController? {
        let responce = speaker?.login(log: login, pass: pass)
        
        switch responce?.type {
        case .success:
            break
        case .error:
            let alert = UIAlertController(title: "Error", message: responce?.message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        default:
            let alert = UIAlertController(title: "Error", message: "APP ERROR", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        return tableViewController(coder: coder, id: responce?.id ?? 0)
    }
    
    @IBAction func buttonTapped(_ sender: Any) {
        
        login = username?.text ?? ""
        pass = password?.text ?? ""
    }
}

class ViewController: UINavigationController {
    

    override func viewDidLoad() {}
}
