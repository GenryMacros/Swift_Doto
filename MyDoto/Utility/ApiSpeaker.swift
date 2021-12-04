//
//  ApiSpeaker.swift
//  MyDoto
//
//  Created by Bohdan Bushko on 27/11/2021.
//

import Foundation
import Alamofire
import Alamofire_Synchronous

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
    let api_url = "http://192.168.0.113:5000"
    
    func get_resource_string(res: Resources) -> String {
        switch res {
        case .users:
            return "/users";
        case .channels:
            return "/channels";
        case .tasks:
            return "/tasks";
        }
    }
    
    func login(log: String, pass: String) throws -> NSDictionary {
        let request_url = api_url + get_resource_string(res: .users);
        let request_body: Parameters = [
            "login": log,
            "pass": pass
        ];

       let responce = Alamofire.request(request_url, method: .post, parameters: request_body, encoding: JSONEncoding.default, headers: nil).responseJSON()
        
        if (responce.result.isSuccess) {
            let statusCode = responce.response?.statusCode ?? 400
            if (statusCode >= 200 && statusCode < 300) {
                if let json = responce.result.value {
                    let mappedJson = json as? NSDictionary;
                    return mappedJson ?? NSDictionary()
                } else {
                    throw RuntimeError("Failed to parse server repsonce");
                }
            } else if (statusCode >= 500) {
                throw RuntimeError("Server is unavailable")
            } else {
                let json = responce.result.value;
                let mappedJson = json as? NSDictionary;
                let mes = mappedJson?.object(forKey: "message") as? String;
                throw RuntimeError(mes ?? "Wrong server responce");
            }
        } else {
            throw RuntimeError("Failed to send request");
        }
    }
    
    func get_channels(user_id: Int) throws -> Array<NSDictionary> {
        let request_url = api_url + get_resource_string(res: .users) + "/" + String(user_id) + get_resource_string(res: .channels);
        
        let responce = Alamofire.request(request_url, method: .get, headers: nil).responseJSON()
    
        return try parseGetResponce(responce: responce, key: "channels")
    }
    
    func get_tasks(channel_id: Int) throws -> Array<NSDictionary> {
        let request_url = api_url + get_resource_string(res: .users) + get_resource_string(res: .channels) + "/" +
            String(channel_id) + get_resource_string(res: .tasks);
        
        let responce = Alamofire.request(request_url, method: .get, headers: nil).responseJSON()
        
        return try parseGetResponce(responce: responce, key: "tasks")
    }
    
    func parseGetResponce(responce: DataResponse<Any>, key: String) throws -> Array<NSDictionary> {
        
        if (responce.result.isSuccess) {
            let statusCode = responce.response?.statusCode ?? 400
            if (statusCode >= 200 && statusCode < 300) {
                if let json = responce.result.value {
                    let mappedJson = json as? NSDictionary;
                    let channels = mappedJson?.object(forKey: key) as? Array<NSDictionary>;
                    return channels ?? Array<NSDictionary>();
                } else {
                    throw RuntimeError("Server didnt return data")
                }
            } else if (statusCode >= 500) {
                throw RuntimeError("Server is unavailable")
            } else {
                let json = responce.result.value;
                let mappedJson = json as? NSDictionary;
                let mes = mappedJson?.object(forKey: "message") as? String;
                throw RuntimeError(mes ?? "Wrong server responce");
            }
        } else {
            throw RuntimeError("Failed to send request");
        }
    }
    
    func add_channel(user_id: Int, channel_name: String) throws {
        let request_url = api_url + get_resource_string(res: .users) + "/" + String(user_id) + get_resource_string(res: .channels);
        let request_body: Parameters = [
            "name": channel_name
        ];
        
        let responce = Alamofire.request(request_url, method: .post, parameters: request_body, encoding: JSONEncoding.default, headers: nil).responseJSON()
        
        try checkResponce(responce: responce)
    }
    
    func delete_channel(channel_id: Int) throws {
        let request_url = api_url + get_resource_string(res: .users) + get_resource_string(res: .channels) + "/" +
            String(channel_id);
        
        let responce = Alamofire.request(request_url, method: .delete).responseJSON()
        
        try checkResponce(responce: responce)
    }
    
    func add_task(channel_id: Int, task_name: String) throws {
        let request_url = api_url + get_resource_string(res: .users) +  get_resource_string(res: .channels) + "/" +
            String(channel_id) + get_resource_string(res: .tasks);
        
        let request_body: Parameters = [
            "name": task_name
        ];
        
        let responce = Alamofire.request(request_url, method: .post, parameters: request_body, encoding: JSONEncoding.default, headers: nil).responseJSON()
        
        try checkResponce(responce: responce)
    }
    
    func delete_task(task_id: Int) throws {
        let request_url = api_url + get_resource_string(res: .users) + get_resource_string(res: .channels) + get_resource_string(res: .tasks) + "/" + String(task_id)
        
        let responce = Alamofire.request(request_url, method: .delete).responseJSON()
        
        try checkResponce(responce: responce)
    }
    
    func reselect_task(task_id: Int) throws {
        let request_url = api_url + get_resource_string(res: .users) + get_resource_string(res: .channels) + get_resource_string(res: .tasks) + "/" + String(task_id)
        
        let responce = Alamofire.request(request_url, method: .put).responseJSON()
        
        try checkResponce(responce: responce)
    }
    
    func checkResponce(responce: DataResponse<Any>) throws {
        if (responce.result.isSuccess) {
            return;
        } else {
            throw RuntimeError("Failed to send request");
        }
    }
}
