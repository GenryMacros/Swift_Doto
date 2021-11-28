//
//  ChannelModel.swift
//  MyDoto
//
//  Created by Bohdan Bushko on 28/11/2021.
//

import Foundation

struct ChannelModel {
    var channel_names: Array<String> = Array<String>();
    var channel_ids: Array<Int> = Array<Int>();
    
    mutating func clear() {
        channel_names.removeAll()
        channel_ids.removeAll()
    }
}
