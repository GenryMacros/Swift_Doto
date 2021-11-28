//
//  ApiSpeaker.swift
//  MyDoto
//
//  Created by Bohdan Bushko on 27/11/2021.
//

import Foundation
import Alamofire
import Alamofire_Synchronous

enum ResponceType {
    case success
    case error
}

struct Responce {
    var type: ResponceType = .success;
    var message: String = "";
    var id: Int?;
}

struct RuntimeError: Error {
    let message: String

    init(_ message: String) {
        self.message = message
    }

    public var localizedDescription: String {
        return message
    }
}

class ApiSpeaker {
    enum Resources {
        case users
        case channels
        case tasks
    }
    
    static var login = ""
    static var password = ""
    let api_url = "http://192.168.0.113:5000/"
    
    func get_resource_string(res: Resources) -> String {
        switch res {
        case .users:
            return "users";
        case .channels:
            return "channels";
        case .tasks:
            return "tasks";
        }
    }
    
    func login(log: String, pass: String) -> Responce{
        let request_url = api_url + get_resource_string(res: .users);
        let request_body: Parameters = [
            "login": log,
            "pass": pass
        ];
        var funcResponce: Responce = Responce();

       let responce = Alamofire.request(request_url, method: .post, parameters: request_body, encoding: JSONEncoding.default, headers: nil).responseJSON()
        
        if (responce.result.isSuccess) {
            if let json = responce.result.value {
                let mappedJson = json as? NSDictionary;
                let userId = mappedJson?.object(forKey: "id");
                
                if (userId == nil) {
                    funcResponce.message = "Wrong server responce";
                    funcResponce.type = .error;
                } else {
                    funcResponce.id = userId as? Int;
                    funcResponce.type = .success;
                }
                
            } else {
                funcResponce.message = "Wrong server responce";
                funcResponce.type = .error;
            }
        } else {
            switch responce.response?.statusCode {
            case 406:
                let json = responce.result.value;
                let mappedJson = json as? NSDictionary;
                let mes = mappedJson?.object(forKey: "message") as? String;
                funcResponce.message = mes ?? "Wrong server responce";
            default:
                funcResponce.message = "Wrong server responce";
                funcResponce.type = .error;
            }
        }
       
        return funcResponce;
    }
    
    func get_channels(user_id: Int) throws -> Array<NSDictionary> {
        let request_url = api_url + get_resource_string(res: .users) + "/" + String(user_id) + "/" + get_resource_string(res: .channels);
        
        let responce = Alamofire.request(request_url, method: .get, headers: nil).responseJSON()
        
        if (responce.result.isSuccess) {
            if let json = responce.result.value {
                let mappedJson = json as? NSDictionary;
                let channels = mappedJson?.object(forKey: "channels") as? Array<NSDictionary>;
                return channels ?? Array<NSDictionary>();
            } else {
                throw RuntimeError("Server didnt return data")
            }
        } else {
            throw RuntimeError("Failed to send request");
        }
    }
    
    func get_tasks(user_id: Int, channel_id: Int) throws -> Array<NSDictionary> {
        let request_url = api_url + get_resource_string(res: .users) + "/" + String(user_id) + "/" + get_resource_string(res: .channels) + "/" +
            String(channel_id) + "/" + get_resource_string(res: .tasks);
        
        let responce = Alamofire.request(request_url, method: .get, headers: nil).responseJSON()
        
        if (responce.result.isSuccess) {
            if let json = responce.result.value {
                let mappedJson = json as? NSDictionary;
                let channels = mappedJson?.object(forKey: "tasks") as? Array<NSDictionary>;
                return channels ?? Array<NSDictionary>();
            } else {
                throw RuntimeError("Server didnt return data")
            }
        } else {
            throw RuntimeError("Failed to send request");
        }
    }
    
    func add_channel(user_id: Int, channel_name: String) throws {
        let request_url = api_url + get_resource_string(res: .users) + "/" + String(user_id) + "/" + get_resource_string(res: .channels);
        let request_body: Parameters = [
            "name": channel_name
        ];
        
        let responce = Alamofire.request(request_url, method: .post, parameters: request_body, encoding: JSONEncoding.default, headers: nil).responseJSON()
        
        if (responce.result.isSuccess) {
            return;
        } else {
            throw RuntimeError("Failed to send request");
        }
    }
    
    func delete_channel(user_id: Int, channel_id: Int) throws {
        let request_url = api_url + get_resource_string(res: .users) + "/" + String(user_id) + "/" + get_resource_string(res: .channels) + "/" +
            String(channel_id);
        
        let responce = Alamofire.request(request_url, method: .delete).responseJSON()
        
        if (responce.result.isSuccess) {
            return;
        } else {
            throw RuntimeError("Failed to send request");
        }
    }
    
    func add_task(user_id: Int, channel_id: Int, task_name: String) throws {
        let request_url = api_url + get_resource_string(res: .users) + "/" + String(user_id) + "/" + get_resource_string(res: .channels) + "/" +
            String(channel_id) + "/" + get_resource_string(res: .tasks);
        
        let request_body: Parameters = [
            "name": task_name
        ];
        
        let responce = Alamofire.request(request_url, method: .post, parameters: request_body, encoding: JSONEncoding.default, headers: nil).responseJSON()
        
        if (responce.result.isSuccess) {
            return;
        } else {
            throw RuntimeError("Failed to send request");
        }
    }
    
    func delete_task(user_id: Int, channel_id: Int, task_id: Int) throws {
        let request_url = api_url + get_resource_string(res: .users) + "/" + String(user_id) + "/" + get_resource_string(res: .channels) + "/" +
            String(channel_id) + "/" + get_resource_string(res: .tasks) + "/" +
            String(task_id);
        
        let responce = Alamofire.request(request_url, method: .delete).responseJSON()
        
        if (responce.result.isSuccess) {
            return;
        } else {
            throw RuntimeError("Failed to send request");
        }
    }
}
