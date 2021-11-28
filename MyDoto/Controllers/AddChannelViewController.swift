//
//  AddChannelViewController.swift
//  MyDoto
//
//  Created by Bohdan Bushko on 28/11/2021.
//

import UIKit
import Alamofire

class AddChannelViewController: UIViewController {
    var user_id: Int = 0;
    @IBOutlet var text_field: UITextField!
    
    var speaker: ApiSpeaker = ApiSpeaker();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func on_button_tap(_ sender: Any) {
        if (text_field.text == "") {
            let alert = UIAlertController(title: "Error", message: "Text field must be not empty", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            do {
                try speaker.add_channel(user_id: user_id, channel_name: text_field.text ?? "default")
                let alert = UIAlertController(title: "Success", message: "Channel added!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            } catch {
                let alert = UIAlertController(title: "Error", message: "Failed to add channel", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func set_user_id(id: Int) {
        user_id = id;
    }
}
