//
//  ViewController.swift
//  MyDoto
//
//  Created by Bohdan Bushko on 21/11/2021.
//

import UIKit
import Alamofire

struct appConfData {
    static var username_g = ""
    static var password_g = ""
    static let api_url = "http://change.me/"
}

struct User {
    var username: String?;
}
class EnterUsernameController : UIViewController {
    var mainController:ViewController? = nil
    @IBOutlet var username: UITextField!
    
    @IBOutlet var password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBSegueAction func toChannelsList(_ coder: NSCoder) -> tableViewController? {
        
        let request_params: Parameters = [
            "username": appConfData.username_g,
            "password": appConfData.password_g
        ]
        
        let request = AF.request(appConfData.api_url, method: .post, parameters: request_params, encoding: JSONEncoding.default, headers: nil)
        
        switch request.response?.statusCode {
        case 200?:
            request.responseJSON {
                User in do {
                    
                }
            }
            break;
        case 400?:
            break;
        default:
            break;
        }
        let alert = UIAlertController(title: "Error", message: "Wrong username or password", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        return tableViewController(coder: coder)
    }
    
    @IBAction func buttonTapped(_ sender: Any) {
        appConfData.username_g = username?.text ?? ""
        
        appConfData.password_g = password?.text ?? ""
        /*
        let request = AF.request(appConfData.api_url, method: .post)
        
        request.responseJSON { (data) in
            print(data)
        }
         */
    }
}

class ViewController: UINavigationController {
    

    override func viewDidLoad() {}
}
