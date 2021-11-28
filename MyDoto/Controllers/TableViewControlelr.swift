//
//  TableViewControlelr.swift
//  MyDoto
//
//  Created by Bohdan Bushko on 21/11/2021.
//
import UIKit
import Alamofire

class tableViewController : UIViewController {
    let CELL_ID = "channelCell";
    var user_id: Int = 0;
    
    var speaker: ApiSpeaker = ApiSpeaker();
    var channelModel: ChannelModel = ChannelModel();
    
    @IBOutlet var tableView: UITableView!
    
    required init?(coder aDecoder: NSCoder, id: Int) {
        super.init(coder: aDecoder)
        user_id = id
        speaker = ApiSpeaker()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func loadData() {
        do {
            let channels = try speaker.get_channels(user_id: user_id)
            for channel in channels {
                channelModel.channel_names.append(channel["Name"] as! String)
                channelModel.channel_ids.append(channel["ID"] as! Int)
            }
        } catch let error {
            let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    @IBSegueAction func on_create_tap(_ coder: NSCoder) -> AddChannelViewController? {
        var controller = AddChannelViewController(coder: coder)
        controller?.set_user_id(id: user_id)
        return controller
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: CELL_ID)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        channelModel.clear()
        loadData()
        tableView.reloadData()
    }
    
}

extension tableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return channelModel.channel_names.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_ID, for: indexPath)
        cell.textLabel?.text = channelModel.channel_names[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView,
                                 commit editingStyle: UITableViewCell.EditingStyle,
                                 forRowAt indexPath: IndexPath) {
        do {
            try speaker.delete_channel(user_id: user_id, channel_id: channelModel.channel_ids[indexPath.row])
            channelModel.clear()
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
        let resultViewControlelr = self.storyboard?.instantiateViewController(identifier: "TasksTableViewController") as! TasksTableViewController
        
        resultViewControlelr.set_id(id: channelModel.channel_ids[indexPath.row])
        resultViewControlelr.set_channel_name(name: channelModel.channel_names[indexPath.row])
        self.navigationController?.pushViewController(resultViewControlelr, animated: true)
    }
    
    
}

extension tableViewController: UITableViewDelegate {
}
