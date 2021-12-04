//
//  ViewController.swift
//  MyDoto
//
//  Created by Bohdan Bushko on 21/11/2021.
//

import UIKit
import Alamofire

class LoginController : UIViewController {
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
    
    @IBSegueAction func toChannelsList(_ coder: NSCoder) -> ChannelsTableViewController? {
        var responce : NSDictionary?;
        do {
            responce = try speaker?.login(log: login, pass: pass)
        } catch let error {
            let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return ChannelsTableViewController(coder: coder, id: 0)
        }
        return ChannelsTableViewController(coder: coder, id: responce?["id"] as! Int)
    }
    
    @IBAction func buttonTapped(_ sender: Any) {
        
        login = username?.text ?? ""
        pass = password?.text ?? ""
    }
}

class ViewController: UINavigationController {
    

    override func viewDidLoad() {}
}
