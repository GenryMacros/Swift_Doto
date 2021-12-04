//
//  TasksTableViewController.swift
//  MyDoto
//
//  Created by Bohdan Bushko on 28/11/2021.
//

import UIKit
import Alamofire

class TasksTableViewController: UIViewController, UITableViewDelegate {
    let CELL_ID = "listCell";
    
    var channel_id: Int = 0;
    var user_id: Int = 0;
    var channel_name: String = "";
    var taskModel: TaskModel = TaskModel();
    var speaker: ApiSpeaker = ApiSpeaker();
    
    @IBOutlet var tableView: UITableView!
    
    @IBSegueAction func on_task_add_tap(_ coder: NSCoder) -> AddTaskViewController? {
        let controller = AddTaskViewController(coder: coder);
        controller?.set_user_id(id: user_id);
        controller?.set_channel_id(id: channel_id);
        return controller
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
   
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: CELL_ID)
    }
    func loadData() {
        do {
            let tasks = try speaker.get_tasks(channel_id: channel_id)
            for task in tasks {
                taskModel.task_names.append(task["Name"] as! String)
                taskModel.task_ids.append(task["ID"] as! Int)
                taskModel.task_is_checked.append(task["Selected"] as! Bool)
            }
        } catch let error {
            let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func set_id(id: Int) {
        channel_id = id;
    }
    
    func set_user_id(id: Int){
        user_id = id;
    }
    
    func set_channel_name(name: String) {
        channel_name = name;
    }
    
    override func viewWillAppear(_ animated: Bool) {
        taskModel.clear()
        loadData()
        tableView.reloadData()
    }
}

extension TasksTableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskModel.task_names.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_ID, for: indexPath)
        cell.textLabel?.text = taskModel.task_names[indexPath.row]
        if (taskModel.task_is_checked[indexPath.row]) {
            cell.contentView.backgroundColor = .green
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView,
                                 commit editingStyle: UITableViewCell.EditingStyle,
                                 forRowAt indexPath: IndexPath) {
        do {
            try speaker.delete_task(task_id: taskModel.task_ids[indexPath.row])
            taskModel.clear()
            loadData()
            tableView.reloadData()
            let alert = UIAlertController(title: "Success", message: "Successful deletion!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } catch let error {
            let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        do {
            try speaker.reselect_task(task_id: taskModel.task_ids[indexPath.row])
            taskModel.clear()
            loadData()
            tableView.reloadData()
            if (taskModel.task_is_checked[indexPath.row]) {
                tableView.cellForRow(at: indexPath)?.contentView.backgroundColor = .green
            }
            else {
                tableView.cellForRow(at: indexPath)?.contentView.backgroundColor = .white
            }
        } catch let error {
            let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}
